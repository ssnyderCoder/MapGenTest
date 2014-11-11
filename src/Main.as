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
		
		
		public function Main():void
		{
			super(600, 600);
		}
		
		override public function init():void
		{
			FP.world = new MapWorld();
			super.init();
		}
	}
	
}