package  
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Block 
	{
		public static const TERRAIN_WATER:uint = 0
		public static const TERRAIN_LAND:uint = 1
		public static const TERRAIN_MOUNTAIN:uint = 2
		
		private var id:int;
		private var terrainType:uint;
		public function Block(id:int) 
		{
			this.id = id;
			terrainType = TERRAIN_LAND;
		}
		
		private function setTerrainType(type:uint):Block {
			terrainType = type;
			return this;
		}
		
		public function getTerrainType():uint {
			return terrainType;
		}
		
		public function getTileID():uint {
			return id;
		}
		
		public static const BLOCK_WATER:Block = new Block(0).setTerrainType(TERRAIN_WATER);
		public static const BLOCK_SAND:Block = new Block(1).setTerrainType(TERRAIN_LAND);
		public static const BLOCK_GRASS:Block = new Block(2).setTerrainType(TERRAIN_LAND);
		public static const BLOCK_STONE:Block = new Block(3).setTerrainType(TERRAIN_LAND);
		public static const BLOCK_MOUNTAIN:Block = new Block(4).setTerrainType(TERRAIN_MOUNTAIN);
		public static const BLOCK_ROAD:Block = new Block(5).setTerrainType(TERRAIN_LAND);
		
		private static const blocks:Vector.<Block> = new Vector.<Block>();
		{
			blocks.push(BLOCK_WATER, BLOCK_SAND, BLOCK_GRASS, BLOCK_STONE, BLOCK_MOUNTAIN, BLOCK_ROAD);
		}
		
		public static function getBlock(id:int):Block {
			return blocks[id];
		}
	}

}