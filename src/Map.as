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
		private static const BLOCK_LENGTH:int = 16;
		public static const TILE_LENGTH:int = 16;
		private static const OFFSET_SPEED:Number = 10;
		
		private var timeElapsed:Number = 0;
		private var regions:Vector.<Tilemap> = new Vector.<Tilemap>();
		private var mapgen:MapGen;
		private var xCenterRegion:int=50;
		private var yCenterRegion:int=50;
		public function Map(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
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
				var i:int;
				var j:int;
				//if center has moved right, move leftmost regions to right most edge and regenerate
				while (xCenterRegion < xRegion) {
					var rightRegions:Vector.<Tilemap> = regions.splice(0, 5);
					for (j = 0; j < 5; j++) 
					{
						rightRegions[j].x = (xCenterRegion + 3) * rightRegions[j].width;
						mapgen.generate(rightRegions[j], xCenterRegion + 3, yRegion - 2 + j);
						regions.splice(20 + j, 0, rightRegions[j]);
					}
					xCenterRegion++;
					trace("shifted right!: x:" + xCenterRegion + " y:" + yRegion);
				}
				//if center has moved left, move rightmost regions to left most edge and regenerate
				while (xCenterRegion > xRegion) {
					var leftRegions:Vector.<Tilemap> = regions.splice(20, 5);
					for (j = 0; j < 5; j++) 
					{
						leftRegions[j].x = (xCenterRegion - 3) * leftRegions[j].width;
						mapgen.generate(leftRegions[j], xCenterRegion - 3, yRegion - 2 + j);
						regions.splice(j, 0, leftRegions[j]);
					}
					xCenterRegion--;
					trace("shifted left!: x:" + xCenterRegion + " y:" + yRegion);
				}
				//if center has moved down, move top regions to bottom edge and regenerate
				while (yCenterRegion < yRegion) {
					for (i = 0; i < 5; i++) 
					{
						var top:Vector.<Tilemap> = regions.splice(i*5, 1);
						top[0].y = (yCenterRegion + 3) * top[0].height;
						mapgen.generate(top[0], xRegion - 2 + i, yCenterRegion + 3);
						regions.splice((i+1)*5 - 1, 0, top[0]);
					}
					yCenterRegion++;
					trace("shifted down!: x:" + xRegion + " y:" + yCenterRegion);
				}
				//if center has moved up, move bottom regions to top edge and regenerate
				while (yCenterRegion > yRegion) {
					for (i = 0; i < 5; i++) 
					{
						var bottom:Vector.<Tilemap> = regions.splice((i + 1) * 5 - 1, 1);
						bottom[0].y = (yCenterRegion - 3) * bottom[0].height;
						mapgen.generate(bottom[0], xRegion - 2 + i, yCenterRegion - 3);
						regions.splice(i*5, 0, bottom[0]);
					}
					yCenterRegion--;
					trace("shifted up!: x:" + xRegion + " y:" + yCenterRegion);
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
					var region:Tilemap = regions[j + i * 5];
					var xReg:int = i + xCenterRegion - 2; //(-2, -1, 0, 1 , 2)
					var yReg:int = j + yCenterRegion - 2; //(-2, -1, 0, 1 , 2)
					mapgen.generate(region, xReg, yReg);
					region.x = xReg * region.width; //(-512, -256, 0, 256, 512)
					region.y = yReg * region.height;
				}
			}
		}
		
		private function initRegions():void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					var region:Tilemap = new Tilemap(Assets.BLOCKS, TILE_LENGTH * BLOCK_LENGTH, TILE_LENGTH * BLOCK_LENGTH, BLOCK_LENGTH, BLOCK_LENGTH);
					regions.push(region);
					this.addGraphic(region);
				}
			}
			regenerate();
		}
		
		
	}

}