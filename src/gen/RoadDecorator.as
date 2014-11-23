package gen 
{
	/**
	 * For this to function properly, it must occur after towns are generated.
	 * @author Sean Snyder
	 */
	public class RoadDecorator extends MapDecorator 
	{
		
		public function RoadDecorator(seed:int) 
		{
			super(seed);
		}
		
		override protected function beginGeneration(xReg:int, yReg:int, mapdata:MapData):void 
		{
			var struct:StructureData = findTown(xReg, yReg, mapdata);
			var pop:uint = mapdata.getPopulation(xReg, yReg);
			if (struct && pop > 0) {
				genRoadsAround(struct, mapdata);
			}
		}
		
		private function genRoadsAround(struct:StructureData, mapdata:MapData):void 
		{
			var startX:int = struct.xTile - 1;
			var startY:int = struct.yTile - 1;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					if (i == 0 || j == 0 || i == 3 || j == 3) {
						mapdata.setBlock(startX + i, startY + j, Block.BLOCK_ROAD.getTileID());
					}
				}
			}
		}
		
		//returns the first town found in a region
		private function findTown(xReg:int, yReg:int, mapdata:MapData):StructureData 
		{
			var structures:Vector.<StructureData> = mapdata.getAllStructures(xReg, yReg);
			for each (var item:StructureData in structures) 
			{
				if (item.type == StructureData.TYPE_TOWN) {
					return item;
				}
			}
			return null;
		}
		
	}

}