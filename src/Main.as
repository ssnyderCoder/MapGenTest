package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	[SWF(width="600",height="600",backgroundColor="#000000")]
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Main extends Engine 
	{
		
		public static const WIDTH:int = 600;
		public static const HEIGHT:int = 600;
		public function Main():void
		{
			super(WIDTH, HEIGHT);
		}
		
		override public function init():void
		{
			FP.world = new MapWorld();
			super.init();
		}
	}
	
}