package gen 
{
	import net.flashpunk.FP;
	/**
	 * Primarily used for testing purposes
	 * @author Sean Snyder
	 */
	public class BlockDecorator extends MapDecorator 
	{
		private var blockID:int;
		private var chance:int;
		private var offset:int;
		public function BlockDecorator(seed:int, blockID:int, percentageChance:int, offset:int=0) 
		{
			super(seed);
			this.blockID = blockID;
			this.chance = percentageChance;
			this.offset = offset;
		}
		
		override protected function beginGeneration(xReg:int, yReg:int, mapdata:MapData):void 
		{
			var roll:int = FP.rand(100);
			if(roll < chance){
				//var xBlock:int = xReg * Constants.REGION_LENGTH + FP.rand(16);
				//var yBlock:int = yReg * Constants.REGION_LENGTH + FP.rand(16);
				var xBlock:int = xReg * Constants.REGION_LENGTH + 8 + offset;
				var yBlock:int = yReg * Constants.REGION_LENGTH + 8 + offset;
				//mapdata.setBlock(xBlock, yBlock, blockID);
				mapdata.addStructure(xReg, yReg, new StructureData(xBlock, yBlock, StructureData.TYPE_CAMP));
			}
		}
		
	}

}