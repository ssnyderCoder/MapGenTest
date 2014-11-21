package  
{
	import net.flashpunk.FP;
	/**
	 * Occurs after terrain generation.  Only terrain available to directly query,
	 * though structure generation can be simulated and checked.
	 * @author Sean Snyder
	 */
	public class StructureGen 
	{
		private var seed:int;
		public function StructureGen(seed:int) 
		{
			this.seed = seed;
		}
		
		public function generate(mapdata:MapData, quad:QuadRegionData, xReg:int, yReg:int):void {
			FP.randomSeed = seed;
			const rand1:int = FP.rand(int.MAX_VALUE);
			const rand2:int = FP.rand(int.MAX_VALUE);
			const xSeed:int = xReg * rand1;
			const ySeed:int = yReg * rand2;
			const regSeed:int = xSeed ^ ySeed ^ seed;
			//scanning other terrain will be tricky if done before other quad regions generated
			//structure generation would have to be entirely separate step
			FP.randomSeed = regSeed;
			genCamp(xReg, yReg, mapdata, quad);
			genTown(xReg, yReg, mapdata, quad);
		}
		//TO DO: research uint to int conversion in flash
		private function genCamp(xReg:int, yReg:int, mapdata:MapData, quad:QuadRegionData):void 
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
				var struct:StructureData = new StructureData(xOffset, yOffset, StructureData.TYPE_CAMP);
				mapdata.addStructure(xReg, yReg, struct);
			}
		}
		
		private function genTown(xReg:int, yReg:int, mapdata:MapData, quad:QuadRegionData):void 
		{
			//gen a town in places with high population
			const popValue:int = mapdata.getPopulation(xReg, yReg);
			const maxChance:int = (popValue - 105) / 2;
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
				var struct:StructureData = new StructureData(xOffset, yOffset, StructureData.TYPE_TOWN);
				mapdata.addStructure(xReg, yReg, struct);
			}
		}
		
	}

}