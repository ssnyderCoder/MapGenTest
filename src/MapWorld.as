package  
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MapWorld extends World 
	{
		public function MapWorld() 
		{
			super();
			this.add(new Map());
		}
		
	}

}