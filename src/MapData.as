package  
{
	import flash.utils.Dictionary;
	import gen.BlockDecorator;
	import gen.CityDecorator;
	import gen.MapDecorator;
	import gen.MapGen;
	import gen.RoadDecorator;
	import net.flashpunk.FP;
	/**
	 * Contains all internal data for each region. Renderer and updater classes retrieve information about the map from this class.
	 * @author Sean Snyder
	 */
	public class MapData 
	{
		private var quadRegions:Dictionary = new Dictionary();
		private var populationNoises:Dictionary = new Dictionary(); //each noise affects 16 x 16 regions
		private var mapgen:MapGen;
		private var popgen:MapGen;
		private var decorators:Vector.<MapDecorator>;
		private var adjDecorators:Vector.<MapDecorator>;
		private var seed:int;
		public function MapData() 
		{
			seed = (int)(FP.scale(Math.random(), 0, 1, 0, int.MAX_VALUE));
			FP.randomSeed = seed;
			const mapSeed:int = FP.rand(int.MAX_VALUE);
			const popSeed:int = FP.rand(int.MAX_VALUE);
			mapgen = new MapGen(Constants.REGION_LENGTH, Constants.REGION_LENGTH, mapSeed);
			popgen = new MapGen(16, 16, popSeed);
			setupDecorators();
		}
		
		private function setupDecorators():void 
		{
			decorators = new Vector.<MapDecorator>();
			adjDecorators = new Vector.<MapDecorator>();
			const citySeed:int = FP.rand(int.MAX_VALUE);
			decorators.push(new CityDecorator(citySeed));
			const roadSeed:int = FP.rand(int.MAX_VALUE);
			adjDecorators.push(new RoadDecorator(roadSeed));
			
		}
		
		//returns the block id at the specified coord
		public function getBlock(x:int, y:int):Block {
			const xReg:int = Math.floor(1.0 * x / Constants.REGION_LENGTH);
			const yReg:int = Math.floor(1.0 * y / Constants.REGION_LENGTH);
			const xQuadReg:int = Math.floor(xReg / 4.0);
			const yQuadReg:int = Math.floor(yReg / 4.0);
			var quad:QuadRegionData = getQuad(xReg, yReg);
			const xBlock:int = x - (xReg * Constants.REGION_LENGTH);
			const yBlock:int = y - (yReg * Constants.REGION_LENGTH);
			return quad.getBlock(xBlock, yBlock, xReg - (xQuadReg * 4), yReg - (yQuadReg * 4));
		}
		
		public function setBlock(x:int, y:int, blockID:uint):void {
			const xReg:int = Math.floor(1.0 * x / Constants.REGION_LENGTH);
			const yReg:int = Math.floor(1.0 * y / Constants.REGION_LENGTH);
			const xQuadReg:int = Math.floor(xReg / 4.0);
			const yQuadReg:int = Math.floor(yReg / 4.0);
			var quad:QuadRegionData = getQuad(xReg, yReg);
			const xBlock:int = x - (xReg * Constants.REGION_LENGTH);
			const yBlock:int = y - (yReg * Constants.REGION_LENGTH);
			return quad.setBlock(xBlock, yBlock, xReg - (xQuadReg * 4), yReg - (yQuadReg * 4), blockID);
		}
		
		//get all the blocks for a specific region
		public function getAllBlockIDs(xRegion:int, yRegion:int):Vector.<uint> {
			const xQuadReg:int = Math.floor(xRegion / 4.0);
			const yQuadReg:int = Math.floor(yRegion / 4.0);
			var quad:QuadRegionData = getQuad(xRegion, yRegion);
			return quad.getRegion(xRegion - (xQuadReg * 4), yRegion - (yQuadReg * 4));
		}
		
		//get all the structures for a specific region
		public function getAllStructures(xRegion:int, yRegion:int):Vector.<StructureData> {
			const xQuadReg:int = Math.floor(xRegion / 4.0);
			const yQuadReg:int = Math.floor(yRegion / 4.0);
			var quad:QuadRegionData = getQuad(xRegion, yRegion);
			return quad.getStructures(xRegion - (xQuadReg * 4), yRegion - (yQuadReg * 4));
		}
		
		public function getQuad(xReg:int, yReg:int):QuadRegionData {
			var xQuadReg:int = Math.floor(xReg / 4.0);
			var yQuadReg:int = Math.floor(yReg / 4.0);
			var quad:QuadRegionData = quadRegions[xQuadReg + " " + yQuadReg];
			if (!quad) {
				quad = genQuad(xQuadReg, yQuadReg);
			}
			return quad;
		}
		
		private function genQuad(xQuad:int, yQuad:int):QuadRegionData {
			var quad:QuadRegionData = new QuadRegionData(xQuad, yQuad);
			var xStartReg:int = xQuad * 4;
			var yStartReg:int = yQuad * 4;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					quad.setRegion(i, j, mapgen.generateTerrain(xStartReg + i, yStartReg + j));
				}
			}
			quadRegions[xQuad + " " + yQuad] = quad;
			return quad;
		}
		
		private function genQuadStructures(quad:QuadRegionData, decorator:MapDecorator):void {
			var xStartReg:int = quad.xQuad * 4;
			var yStartReg:int = quad.yQuad * 4;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					decorator.generate(this, xStartReg + i, yStartReg + j);
				}
			}
		}
		
		public function createSurroundingQuads(xReg:int, yReg:int, prevXReg:int=int.MIN_VALUE, prevYReg:int=int.MIN_VALUE):void {
			var xQuadReg:int = Math.floor(xReg / 4.0);
			var yQuadReg:int = Math.floor(yReg / 4.0);
			var xPrevQuadReg:int = Math.floor(prevXReg / 4.0);
			var yPrevQuadReg:int = Math.floor(prevYReg / 4.0);
			if (xQuadReg == xPrevQuadReg && yQuadReg == yPrevQuadReg) {
				return;
			}
			//generate and decorate the 5 x 5 box of quads
			makeQuadsInRange(xQuadReg, yQuadReg, 2);
			//decorate the 3x3 box of quads
			decorateAdjQuads(xQuadReg, yQuadReg);
		}
		
		private function decorateAdjQuads(xQuadReg:int, yQuadReg:int):void 
		{
			const range:int = 1;
			for (var decID:int = 0; decID < adjDecorators.length; decID++) 
			{		
				for (var i:int = -range; i < range+1; i++) 
				{
					for (var j:int = -range; j < range+1; j++) 
					{
						var xQ:int = xQuadReg + i;
						var yQ:int = yQuadReg + j;
						var quad:QuadRegionData = quadRegions[xQ + " " + yQ];
						if (!quad) {
							quad = genQuad(xQ, yQ);
						}
						if (!quad.hasGeneratedAdj) {
							genQuadStructures(quad, adjDecorators[decID]);
							if (decID == adjDecorators.length - 1) {
								quad.hasGeneratedAdj = true;
							}
						}
					}
				}
			}
		}
		
		private function makeQuadsInRange(xQuadReg:int, yQuadReg:int, range:int):void 
		{
			for (var decID:int = 0; decID < decorators.length; decID++) 
			{		
				for (var i:int = -range; i < range+1; i++) 
				{
					for (var j:int = -range; j < range+1; j++) 
					{
						var xQ:int = xQuadReg + i;
						var yQ:int = yQuadReg + j;
						var quad:QuadRegionData = quadRegions[xQ + " " + yQ];
						if (!quad) {
							quad = genQuad(xQ, yQ);
						}
						if (!quad.hasGeneratedStructures) {
							genQuadStructures(quad, decorators[decID]);
							if (decID == decorators.length - 1) {
								quad.hasGeneratedStructures = true;
							}
						}
					}
				}
			}
		}
		
		public function getPopulation(xRegion:int, yRegion:int):uint {
			const xPop:int = Math.floor(xRegion / 16.0);
			const yPop:int = Math.floor(yRegion / 16.0);
			var popNoise:Vector.<uint> = populationNoises[xPop + " " + yPop];
			if (!popNoise) {
				popNoise = popgen.generateNoise(xPop, yPop);
				populationNoises[xPop + " " + yPop] = popNoise;
			}
			const xIndex:int = xRegion - (xPop * 16);
			const yIndex:int = yRegion - (yPop * 16);
			return popNoise[xIndex + yIndex * 16];
		}
		
		public function addStructure(xRegion:int, yRegion:int, struct:StructureData):void {
			const xQuadReg:int = Math.floor(xRegion / 4.0);
			const yQuadReg:int = Math.floor(yRegion / 4.0);
			var quad:QuadRegionData = getQuad(xRegion, yRegion);
			return quad.addStructure(xRegion - (xQuadReg * 4), yRegion - (yQuadReg * 4), struct);
		}
	}

}