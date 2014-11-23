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
			if (struct) {
				genRoadsAround(struct, mapdata);
			}
			//only activate this if is first region of quad (0,0)
			if (xReg % 4 == 0 && yReg % 4 == 0) {
				const xQuad:int = Math.floor(xReg / 4.0);
				const yQuad:int = Math.floor(yReg / 4.0);
				genRoadsBetweenTowns(xReg, yReg, mapdata);
			}
		}
		
		private function genRoadsBetweenTowns(xQuad:int, yQuad:int, mapdata:MapData):void 
		{
			//get all towns in this quad and adj surrounding quads
			//all towns that are in adjacent regions are connected with roads
			//generate all roads that appear in this quad
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