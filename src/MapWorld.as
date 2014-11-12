package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MapWorld extends World 
	{
		private var timePassed:Number = 0;
		private var map:Map;
		public function MapWorld() 
		{
			super();
			map = new Map();
			this.add(map);
			var canvas:Canvas = new Canvas(9, 9);
			canvas.fill(new Rectangle(0, 0, 9, 9), 0xCCCC11);
			canvas.fill(new Rectangle(3, 3, 3, 3), 0x1111CC);
			canvas.scrollX = 0;
			canvas.scrollY = 0;
			this.addGraphic(canvas, -1, (Main.WIDTH / 2) - 1, (Main.HEIGHT / 2) - 1);
		}
		
		override public function update():void 
		{
			super.update();
			timePassed += FP.elapsed;
			if(timePassed > 0.01){
				FP.camera.x += 0;
				FP.camera.y += 1;
				timePassed -= 0.01;
			}
			map.updateCenter(FP.camera.x + (Main.WIDTH / 2), FP.camera.y + (Main.HEIGHT / 2));
		}
		
	}

}