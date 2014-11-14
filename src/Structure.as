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
		
		public function Structure(tileX:int=0, tileY:int=0, id:int=0) 
		{
			this.x = tileX * Constants.BLOCK_LENGTH;
			this.y = tileY * Constants.BLOCK_LENGTH;
			var sprite:Spritemap = new Spritemap(Assets.OBJECTS, 32, 32);
			sprite.frame = id;
			this.graphic = sprite;
		}
		
	}

}