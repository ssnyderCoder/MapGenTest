package  
{
	import flash.utils.Dictionary;
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
		private var seed:int;
		public function MapData() 
		{
			seed = (int)(FP.scale(Math.random(), 0, 1, 0, int.MAX_VALUE));
			FP.randomSeed = seed;
			const mapSeed:int = FP.rand(int.MAX_VALUE);
			const popSeed:int = FP.rand(int.MAX_VALUE);
			mapgen = new MapGen(Constants.REGION_LENGTH, Constants.REGION_LENGTH, mapSeed);
			popgen = new MapGen(16, 16, popSeed);
		}
		
		//returns the block id at the specified coord - still untested
		public function getBlock(x:int, y:int):Block {
			const xReg:int = Math.floor(1.0 * x / Constants.REGION_LENGTH);
			const yReg:int = Math.floor(1.0 * y / Constants.REGION_LENGTH);
			const xQuadReg:int = Math.floor(xReg / 4.0);
			const yQuadReg:int = Math.floor(yReg / 4.0);
			var quad:QuadRegionData = quadRegions[xQuadReg + " " + yQuadReg];
			if (!quad) {
				quad = genQuad(xQuadReg, yQuadReg);
			}
			const theBlocks:Vector.<uint> = quad.getRegion(xReg - (xQuadReg * 4), yReg - (yQuadReg * 4));
			const xBlock:int = x - (xReg * Constants.REGION_LENGTH);
			const yBlock:int = y - (yReg * Constants.REGION_LENGTH);
			return Block.getBlock(theBlocks[xBlock + yBlock*Constants.REGION_LENGTH]);
		}
		
		//get all the blocks for a specific region
		public function getAllBlockIDs(xRegion:int, yRegion:int):Vector.<uint> {
			var xQuadReg:int = Math.floor(xRegion / 4.0);
			var yQuadReg:int = Math.floor(yRegion / 4.0);
			var quad:QuadRegionData = quadRegions[xQuadReg + " " + yQuadReg];
			if (!quad) {
				quad = genQuad(xQuadReg, yQuadReg);
			}
			return quad.getRegion(xRegion - (xQuadReg * 4), yRegion - (yQuadReg * 4));
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
	}

}