package gen
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class CityDecorator extends MapDecorator 
	{
		
		public function CityDecorator(seed:int) 
		{
			super(seed);
		}
		
		override protected function beginGeneration(xReg:int, yReg:int, mapdata:MapData):void 
		{
			genCamp(xReg, yReg, mapdata);
			genTown(xReg, yReg, mapdata);
		}
		
		//TO DO: research uint to int conversion in flash
		private function genCamp(xReg:int, yReg:int, mapdata:MapData):void 
		{
			//gen a camp in places with fairly low population
			const popValue:int = mapdata.getPopulation(xReg, yReg);
			const maxChance:int = 35 - Math.abs(popValue - 70);
			//const maxChance:int = 25;
			const roll:int = FP.rand(100);
			//const roll:int = 0;
			if (roll < maxChance) {
				//do block checking to make sure it spawns on land only
				var xOffset:int = FP.rand(14);
				var yOffset:int = FP.rand(14);
				var xTile:int = (xReg * Constants.REGION_LENGTH) + xOffset;
				var yTile:int = (yReg * Constants.REGION_LENGTH) + yOffset;
				if (mapdata.getBlock(xTile, yTile).getTerrainType() != Block.TERRAIN_LAND ||
				    mapdata.getBlock(xTile + 1, yTile).getTerrainType() != Block.TERRAIN_LAND ||
					mapdata.getBlock(xTile, yTile + 1).getTerrainType() != Block.TERRAIN_LAND ||
					mapdata.getBlock(xTile + 1, yTile + 1).getTerrainType() != Block.TERRAIN_LAND) {
					return;
				}
				var struct:StructureData = new StructureData(xTile, yTile, StructureData.TYPE_CAMP);
				mapdata.addStructure(xReg, yReg, struct);
			}
		}
		
		private function genTown(xReg:int, yReg:int, mapdata:MapData):void 
		{
			//gen a town in places with high population
			const popValue:int = mapdata.getPopulation(xReg, yReg);
			//const maxChance:int = (popValue - 105) / 2;
			const maxChance:int = 25;
			const roll:int = FP.rand(100);
			//const roll:int = 30;
			if (roll < maxChance) {
				//do block checking to make sure it spawns on land only
				var xOffset:int = FP.rand(14);
				var yOffset:int = FP.rand(14);
				var xTile:int = (xReg * Constants.REGION_LENGTH) + xOffset;
				var yTile:int = (yReg * Constants.REGION_LENGTH) + yOffset;
				if (mapdata.getBlock(xTile, yTile).getTerrainType() != Block.TERRAIN_LAND ||
				    mapdata.getBlock(xTile + 1, yTile).getTerrainType() != Block.TERRAIN_LAND ||
					mapdata.getBlock(xTile, yTile + 1).getTerrainType() != Block.TERRAIN_LAND ||
					mapdata.getBlock(xTile + 1, yTile + 1).getTerrainType() != Block.TERRAIN_LAND) {
					return;
				}
				var struct:StructureData = new StructureData(xTile, yTile, StructureData.TYPE_TOWN);
				mapdata.addStructure(xReg, yReg, struct);
			}
		}
		
	}

}