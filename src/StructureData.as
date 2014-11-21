package  
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class StructureData 
	{
		public static const TYPE_TOWN:int = 0;
		public static const TYPE_CAMP:int = 1;
		
		public var type:int;
		public var xTile:int;
		public var yTile:int;
		
		public function StructureData(x:int, y:int, type:int) {
			this.xTile = x;
			this.yTile = y;
			this.type = type;
		}
		
	}

}