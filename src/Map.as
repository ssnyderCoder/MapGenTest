package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Map extends Entity 
	{
		public static const BLOCK_LENGTH:int = 16;
		public static const TILE_LENGTH:int = 16;
		private var timeElapsed:Number = 0;
		private var regions:Vector.<RegionTileMap> = new Vector.<RegionTileMap>(25, true);
		private var mapgen:MapGen;
		private var mapdata:MapData;
		private var xCenterRegion:int=50;
		private var yCenterRegion:int=50;
		public function Map(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			mapdata = new MapData();
			mapgen = new MapGen(TILE_LENGTH, TILE_LENGTH, (int)(FP.scale(Math.random(), 0, 1, int.MIN_VALUE, int.MAX_VALUE)));
			
			initRegions();
		}
		
		public function updateCenter(xPos:Number, yPos:Number):void 
		{
			//problem: need to round down rather than use int division for negative numbers to work properly
			var xTile:int = Math.floor(xPos / BLOCK_LENGTH);
			var yTile:int = Math.floor(yPos / BLOCK_LENGTH);
			var xRegion:int = Math.floor(xTile / TILE_LENGTH);
			var yRegion:int = Math.floor( yTile / TILE_LENGTH);
			if (xRegion != xCenterRegion || yRegion != yCenterRegion) {
				//if center vastly different, then just regenerate everything
				if(Math.abs(xRegion - xCenterRegion) > 3 || Math.abs(yRegion - yCenterRegion) > 3){
					xCenterRegion = xRegion;
					yCenterRegion = yRegion;
					regenerate();
					trace("Regenerated!: x:" + xCenterRegion + " y:" + yCenterRegion);
				}
				else {
					var check:Vector.<Boolean> = new Vector.<Boolean>(25, true);
					var stack:Vector.<RegionTileMap> = new Vector.<RegionTileMap>();
					xCenterRegion = xRegion;
					yCenterRegion = yRegion;
					var i:int;
					var j:int;
					var region:RegionTileMap;
					for (i = 0; i < 5*5; i++) 
					{
						region = regions[i];
						if (Math.abs(xCenterRegion - region.xRegion) <= 2 && Math.abs(yCenterRegion - region.yRegion) <= 2) {
							var xIndex:int = region.xRegion + 2 - xCenterRegion; 
							var yIndex:int = region.yRegion + 2 - yCenterRegion; 
							check[yIndex + xIndex * 5] = true;
						}else {
							stack.push(region);
						}
					}
					
					for (i = 0; i < 5; i++) 
					{
						for (j = 0; j < 5; j++) 
						{
							if (check[j + i * 5] != true) {
								region = stack.pop();
								region.xRegion = i - 2 + xCenterRegion;
								region.yRegion = j - 2 + yCenterRegion;
								mapgen.generate(region.tilemap, region.xRegion, region.yRegion);
							}
						}
					}
				}
			}
		}
		
		private function regenerate():void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					//036
					//147
					//258
					//if center is (0,0)
					var region:RegionTileMap = regions[j + i * 5];
					region.xRegion = i + xCenterRegion - 2; //(-2, -1, 0, 1 , 2)
					region.yRegion = j + yCenterRegion - 2; //(-2, -1, 0, 1 , 2)
					mapgen.generate(region.tilemap, region.xRegion, region.yRegion);
				}
			}
		}
		
		private function initRegions():void 
		{
			for (var i:int = 0; i < 5*5; i++) 
			{
				var region:RegionTileMap = new RegionTileMap();
				region.xRegion = 0;
				region.yRegion = 0;
				regions[i] = region;
				this.addGraphic(region.tilemap);
			}
			regenerate();
		}
		
		private function setTiles(tilemap:Tilemap, xReg:int, yReg:int):void {
			var tiles:Vector.<uint> = mapdata.getAllBlockIDs(xReg, yReg);
		}
		
		
	}

}