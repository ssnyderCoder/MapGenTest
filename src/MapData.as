package  
{
	/**
	 * Contains all internal data for each region. Renderer and updater classes retrieve information about the map from this class.
	 * @author Sean Snyder
	 */
	public class MapData 
	{
		
		public function MapData() 
		{
			
		}
		
		//returns the block id at the specified coord
		public function getBlock(x:int, y:int):Block {
			return null;
		}
		
		//get all the blocks for a specific region
		public function getAllBlockIDs(xRegion:int, yRegion:int):Vector.<uint> {
			var vec:Vector.<uint> =  new Vector.<uint>();
			vec.push(1, 2, 3, 4, 5)
		}
		
	}

}