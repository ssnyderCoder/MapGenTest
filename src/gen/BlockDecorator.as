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
		public function BlockDecorator(seed:int, blockID:int, percentageChance:int) 
		{
			super(seed);
			this.blockID = blockID;
			this.chance = percentageChance;
		}
		
		override protected function beginGeneration(xReg:int, yReg:int, mapdata:MapData):void 
		{
			var roll:int = FP.rand(100);
			if(roll < chance){
				var xBlock:int = xReg * Constants.REGION_LENGTH + FP.rand(16);
				var yBlock:int = yReg * Constants.REGION_LENGTH + FP.rand(16);
				mapdata.setBlock(xBlock, yBlock, blockID);
			}
		}
		
	}

}