package  
{
	import net.flashpunk.FP;
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
		}
		
		override public function update():void 
		{
			super.update();
			timePassed += FP.elapsed;
			if(timePassed > 0.01){
				FP.camera.x += -4;
				FP.camera.y += 4;
				timePassed -= 0.01;
			}
			map.updateCenter(FP.camera.x + (Main.WIDTH / 2), FP.camera.y + (Main.HEIGHT / 2));
			
		}
		
	}

}