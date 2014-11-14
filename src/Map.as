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
		private var timeElapsed:Number = 0;
		private var regions:Vector.<RegionTileMap> = new Vector.<RegionTileMap>(25, true);
		private var mapdata:MapData;
		private var xCenterRegion:int=50;
		private var yCenterRegion:int=50;
		public function Map(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			mapdata = new MapData();
			
		}
		
		override public function added():void 
		{
			super.added();
			initRegions();
		}
		
		public function updateCenter(xPos:Number, yPos:Number):void 
		{
			//problem: need to round down rather than use int division for negative numbers to work properly
			var xTile:int = Math.floor(xPos / Constants.BLOCK_LENGTH);
			var yTile:int = Math.floor(yPos / Constants.BLOCK_LENGTH);
			var xRegion:int = Math.floor(xTile / Constants.REGION_LENGTH);
			var yRegion:int = Math.floor( yTile / Constants.REGION_LENGTH);
			if (xRegion != xCenterRegion || yRegion != yCenterRegion) {
				//if center vastly different, then just regenerate everything
				if(Math.abs(xRegion - xCenterRegion) > 3 || Math.abs(yRegion - yCenterRegion) > 3){
					xCenterRegion = xRegion;
					yCenterRegion = yRegion;
					regenerate();
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
							check[xIndex + yIndex * 5] = true;
						} else {
							stack.push(region);
						}
					}
					
					for (j = 0; j < 5; j++) 
					{
						for (i = 0; i < 5; i++) 
						{
							if (check[i + j * 5] != true) {
								region = stack.pop();
								unloadStructures(region.xRegion, region.yRegion);
								region.xRegion = i - 2 + xCenterRegion;
								region.yRegion = j - 2 + yCenterRegion;
								setTiles(region.tilemap, region.xRegion, region.yRegion);
								loadStructures(region.xRegion, region.yRegion);
							}
						}
					}
				}
			}
		}
		
		private function regenerate():void 
		{
			for (var j:int = 0; j < 5; j++) 
			{
				for (var i:int = 0; i < 5; i++) 
				{
					var region:RegionTileMap = regions[i + j * 5];
					unloadStructures(region.xRegion, region.yRegion);
					region.xRegion = i + xCenterRegion - 2;
					region.yRegion = j + yCenterRegion - 2;
					setTiles(region.tilemap, region.xRegion, region.yRegion);
					loadStructures(region.xRegion, region.yRegion);
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
			tilemap.setAllTiles(tiles);
		}
		
		private function loadStructures(xReg:int, yReg:int):void {
			var structs:Vector.<StructureData> = mapdata.getAllStructures(xReg, yReg);
			for each (var item:StructureData in structs) 
			{
				const xTile:int = xReg * Constants.REGION_LENGTH + item.xTileRegion;
				const yTile:int = yReg * Constants.REGION_LENGTH + item.yTileRegion;
				var struct:Structure = (Structure)(this.world.create(Structure));
				struct.init(xTile, yTile, item.type);
			}
		}
		
		private function unloadStructures(xReg:int, yReg:int):void {
			var entities:Array = new Array();
			world.getType("Structure", entities);
			for each (var item:Structure in entities) 
			{
				const xR:int = Math.floor(item.x / Constants.BLOCK_LENGTH / Constants.REGION_LENGTH);
				const yR:int = Math.floor(item.y / Constants.BLOCK_LENGTH / Constants.REGION_LENGTH);
				if (xR == xReg && yR == yReg) {
					world.recycle(item);
				}
			}
		}
	}

}