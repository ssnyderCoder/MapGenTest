package  
{
	import net.flashpunk.FP;
	/**
	 * ...
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
			FP.randomSeed = regSeed;
			//scanning other terrain will be tricky if done before other quad regions generated
			//structure generation would have to be entirely separate step
			genCamp(xReg, yReg, mapdata, quad);
			genTown(xReg, yReg, mapdata, quad);
		}
		
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
				var xTile:int = FP.rand(14);
				var yTile:int = FP.rand(14);
				var localXReg:int = xReg - (quad.xQuad * 4);
				var localYReg:int = yReg - (quad.yQuad * 4);
				if (quad.getBlock(xTile, yTile, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
				    quad.getBlock(xTile + 1, yTile, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
					quad.getBlock(xTile, yTile + 1, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
					quad.getBlock(xTile + 1, yTile + 1, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND) {
					return;
				}
				var struct:StructureData = new StructureData(xTile, yTile, StructureData.TYPE_CAMP);
				quad.addStructure(xReg - (quad.xQuad * 4), yReg - (quad.yQuad * 4), struct);
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
				var xTile:int = FP.rand(14);
				var yTile:int = FP.rand(14);
				var localXReg:int = xReg - (quad.xQuad * 4);
				var localYReg:int = yReg - (quad.yQuad * 4);
				if (quad.getBlock(xTile, yTile, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
				    quad.getBlock(xTile + 1, yTile, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
					quad.getBlock(xTile, yTile + 1, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND ||
					quad.getBlock(xTile + 1, yTile + 1, localXReg, localYReg).getTerrainType() != Block.TERRAIN_LAND) {
					return;
				}
				var struct:StructureData = new StructureData(xTile, yTile, StructureData.TYPE_TOWN);
				quad.addStructure(xReg - (quad.xQuad * 4), yReg - (quad.yQuad * 4), struct);
			}
		}
		
	}

}