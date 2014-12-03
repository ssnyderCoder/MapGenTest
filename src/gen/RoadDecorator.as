package gen 
{
	import flash.geom.Point;
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
				genRoadsWithinQuad(xQuad, yQuad, mapdata);
				genRoadsBetweenQuads(xQuad, yQuad, mapdata);
			}
		}
		
		//generates the roads that exist between towns in neighboring quads
		private function genRoadsBetweenQuads(xQuad:int, yQuad:int, mapdata:MapData):void 
		{
			//get all towns in this quad
			//for each neighbor quad
				//get all neighbor quad's towns
				//connect closest towns of this quad and neighbor (n * m)
				//while doing above, also connect towns between quads within certain range (like 1 region)
		}
		
		//generates the roads that exist between towns in this quad
		private function genRoadsWithinQuad(xQuad:int, yQuad:int, mapdata:MapData):void 
		{
			var towns:Vector.<StructureData> = getAllTowns(xQuad, yQuad, mapdata);
			//generate a road between each town (i:0 to n, j:i+1 to n)
			for (var i:int = 0; i < towns.length; i++) 
			{
				for (var j:int = i + 1; j < towns.length; j++) 
				{
					genTownRoad(towns[i], towns[j], mapdata);
				}
			}
		}
		
		private function genTownRoad(startTown:StructureData, endTown:StructureData, mapdata:MapData):void 
		{
			//calculate angle from start town to end towns
			var direction:Point = new Point(endTown.xTile - startTown.xTile, endTown.yTile - startTown.yTile);
			direction.normalize(1);
			var currentX:int = startTown.xTile;
			var currentY:int = startTown.yTile;
			var fraction:Point = new Point(0, 0);
			while (Math.abs(currentX - endTown.xTile) >= 1 && Math.abs(currentY - endTown.yTile) >= 1) {
				fraction.x += direction.x;
				fraction.y += direction.y;
				var coordChanged:Boolean = false;
				if (fraction.x <= -1) {
					fraction.x += 1;
					currentX -= 1;
					coordChanged = true;
				}
				if (fraction.x >= 1) {
					fraction.x -= 1;
					currentX += 1;
					coordChanged = true;
				}
				if (fraction.y <= -1) {
					fraction.y += 1;
					currentY -= 1;
					coordChanged = true;
				}
				if (fraction.y >= 1) {
					fraction.y -= 1;
					currentY += 1;
					coordChanged = true;
				}
				if (coordChanged) {
					mapdata.setBlock(currentX, currentY, Block.BLOCK_ROAD.getTileID());
				}
			}
		}
		
		private function getAllTowns(xQuad:int, yQuad:int, mapdata:MapData):Vector.<StructureData> 
		{
			const xStartReg:int = xQuad * 4;
			const yStartReg:int = yQuad * 4;
			var towns:Vector.<StructureData> = new Vector.<StructureData>();
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					var regStructs:Vector.<StructureData> = mapdata.getAllStructures(xStartReg + i, yStartReg + j);
					for each (var item:StructureData in regStructs) 
					{
						if (item.type == StructureData.TYPE_TOWN)
							towns.push(item);
					}
				}
			}
			return towns;
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