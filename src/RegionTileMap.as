package  
{
	import net.flashpunk.graphics.Tilemap;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	internal final class RegionTileMap 
	{
		private var _tilemap:Tilemap = new Tilemap(Assets.BLOCKS, Constants.REGION_LENGTH * Constants.BLOCK_LENGTH, Constants.REGION_LENGTH * Constants.BLOCK_LENGTH, Constants.BLOCK_LENGTH, Constants.BLOCK_LENGTH);
		private var _xRegion:int = int.MIN_VALUE;
		private var _yRegion:int = int.MIN_VALUE;
		
		public function get tilemap():Tilemap 
		{
			return _tilemap;
		}
		
		public function set tilemap(value:Tilemap):void 
		{
			_tilemap = value;
		}
		
		public function get xRegion():int 
		{
			return _xRegion;
		}
		
		public function set xRegion(value:int):void 
		{
			_xRegion = value;
			_tilemap.x = _xRegion * _tilemap.width;
		}
		
		public function get yRegion():int 
		{
			return _yRegion;
		}
		
		public function set yRegion(value:int):void 
		{
			_yRegion = value;
			_tilemap.y = _yRegion * _tilemap.height;
		}
		
	}

}