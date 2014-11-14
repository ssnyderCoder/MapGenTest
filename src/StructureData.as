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
		public var xTileRegion:int;
		public var yTileRegion:int;
		
		public function StructureData(x:int, y:int, type:int) {
			this.xTileRegion = x;
			this.yTileRegion = y;
			this.type = type;
		}
		
	}

}