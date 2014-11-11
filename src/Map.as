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
		private static const BLOCK_LENGTH:int = 4;
		public static const TILE_LENGTH:int = 64;
		private static const OFFSET_SPEED:Number = 10;
		
		private var timeElapsed:Number = 0;
		private var regions:Vector.<Tilemap> = new Vector.<Tilemap>();
		private var mapgen:MapGen;
		public function Map(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			mapgen= new MapGen(TILE_LENGTH, TILE_LENGTH, (int)(FP.scale(Math.random(), 0, 1, int.MIN_VALUE, int.MAX_VALUE)));
			
			initRegions();
		}
		
		override public function update():void 
		{
			super.update();
			timeElapsed += FP.elapsed;
			if(timeElapsed > 1){
				applyOffset();
				timeElapsed -= 1;
			}
		}
		
		private function applyOffset():void 
		{
			mapgen.addOffset(OFFSET_SPEED, OFFSET_SPEED);
			for (var i:int = 0; i < 3; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					var region:Tilemap = regions[j + i * 3];
					mapgen.generate(region, i, j);
				}
			}
		}
		private function initRegions():void 
		{
			for (var i:int = 0; i < 3; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					var region:Tilemap = new Tilemap(Assets.BLOCKS, TILE_LENGTH * BLOCK_LENGTH, TILE_LENGTH * BLOCK_LENGTH, BLOCK_LENGTH, BLOCK_LENGTH);
					region.x = i * region.width + (i*1);
					region.y = j * region.height + (j*1);
					mapgen.generate(region, i, j);
					regions.push(region);
					this.addGraphic(region);
				}
			}
		}
		
		
	}

}