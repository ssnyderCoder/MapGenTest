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
		private var structures:Vector.<Vector.<StructureData>>;
		private var _hasGeneratedStructures:Boolean = false;
		
		public function QuadRegionData(x:int, y:int) {
			this.xQuad = x;
			this.yQuad = y;
			this.allBlocks = new Vector.<Vector.<uint>>(16);
			this.structures = new Vector.<Vector.<StructureData>>(16);
		}
		
		/**
		 * 
		 * @param	xReg Must be between 0 and 3
		 * @param	yReg Must be between 0 and 3
		 * @param	structure Data for a structure that includes local coordinates for the region it is in
		 */
		public function addStructure(xReg:int, yReg:int, structure:StructureData):void {
			var regStructs:Vector.<StructureData> = structures[xReg + yReg * 4];
			if (!regStructs) {
				regStructs = new Vector.<StructureData>();
				structures[xReg + yReg * 4] = regStructs;
			}
			regStructs.push(structure);
		}
		
		public function getStructures(xReg:int, yReg:int):Vector.<StructureData> {
			var regStructs:Vector.<StructureData> = structures[xReg + yReg * 4];
			if (!regStructs) {
				regStructs = new Vector.<StructureData>();
				structures[xReg + yReg * 4] = regStructs;
			}
			return regStructs;
		}
		
		/**
		 * Sets up a single region of the QuadRegion (local coords)
		 * @param	xReg Must be between 0 and 3
		 * @param	yReg Must be between 0 and 3
		 * @param	blocks the block ids for this region
		 */
		public function setRegion(xReg:int, yReg:int, blocks:Vector.<uint>):void {
			allBlocks[xReg + yReg * 4] = blocks;
		}
		/**
		 * Retrieves a single region of the QuadRegion (local coords)
		 * @param	xReg Must be between 0 and 3
		 * @param	yReg Must be between 0 and 3
		 * @return the block ids for this region
		 */
		public function getRegion(xReg:int, yReg:int):Vector.<uint> {
			return allBlocks[xReg + yReg * 4];
		}
		
		public function getBlock(xBlock:int, yBlock:int, xReg:int, yReg:int):Block {
			var blocks:Vector.<uint> = allBlocks[xReg + yReg * 4];
			return Block.getBlock(blocks[xBlock + yBlock * Constants.REGION_LENGTH]);
		}
		
		public function setBlock(xBlock:int, yBlock:int, xReg:int, yReg:int, blockID:uint):void {
			var blocks:Vector.<uint> = allBlocks[xReg + yReg * 4];
			blocks[xBlock + yBlock * Constants.REGION_LENGTH] = blockID;
		}
		
		public function get hasGeneratedStructures():Boolean 
		{
			return _hasGeneratedStructures;
		}
		
		public function set hasGeneratedStructures(value:Boolean):void 
		{
			_hasGeneratedStructures = value;
		}
		
	}

}