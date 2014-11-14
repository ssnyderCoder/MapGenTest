package  
{
	/**
	 * This class contains 16 regions, in a 4x4 grid. A total of 16*16*16 blocks (4096 blocks).
	 * @author Sean Snyder
	 */
	public class QuadRegionData 
	{
		
		public var xQuad:int;
		public var yQuad:int;
		private var allBlocks:Vector.<Vector.<uint>>;
		
		public function QuadRegionData(x:int, y:int) {
			this.xQuad = x;
			this.yQuad = y;
			this.allBlocks = new Vector.<Vector.<uint>>();
		}
		
		/**
		 * Sets up a single region of the QuadRegion
		 * @param	xReg Must be between 0 and 3
		 * @param	yReg Must be between 0 and 3
		 * @param	blocks the block ids for this region
		 */
		public function setRegion(xReg:int, yReg:int, blocks:Vector.<uint>):void {
			allBlocks[yReg + xReg * 4] = blocks;
		}
		/**
		 * Retrieves a single region of the QuadRegion
		 * @param	xReg Must be between 0 and 3
		 * @param	yReg Must be between 0 and 3
		 * @return the block ids for this region
		 */
		public function getRegion(xReg:int, yReg:int):Vector.<uint> {
			return allBlocks[yReg + xReg * 4];
		}
		
	}

}