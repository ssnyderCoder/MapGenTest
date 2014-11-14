package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Structure extends Entity 
	{
		private var sprite:Spritemap;
		
		public function Structure(tileX:int=0, tileY:int=0, id:int=0) 
		{
			sprite = new Spritemap(Assets.OBJECTS, 32, 32);
			this.graphic = sprite;
			this.type = "Structure";
		}
		
		public function init(tileX:int = 0, tileY:int = 0, id:int = 0):void {
			this.x = tileX * Constants.BLOCK_LENGTH;
			this.y = tileY * Constants.BLOCK_LENGTH;
			sprite.frame = id;
		}
		
	}

}