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
		private var mapgen:MapGen;
		public function MapData() 
		{
			mapgen = new MapGen(Constants.REGION_LENGTH, Constants.REGION_LENGTH, (int)(FP.scale(Math.random(), 0, 1, int.MIN_VALUE, int.MAX_VALUE)));
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
	}

}