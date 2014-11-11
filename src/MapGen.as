package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Tilemap;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MapGen 
	{
		
		private var width:int;
		private var height:int;
		private var seed:int;
		private var numOctaves:int = 3;
		private var timeOffsets:Array = new Array();
		public function MapGen(width:int, height:int, seed:int) 
		{
			this.width = width;
			this.height = height;
			this.seed = seed;
			for (var i:int = 0; i < numOctaves; i++) 
			{
				timeOffsets.push(new Point(0, 0));
			}
		}
		
		public function addOffset(x:Number, y:Number):void {
			for each (var item:Point in timeOffsets) 
			{
				item.x += x;
				item.y += y;
			}
		}
		
		public function generate(tiles:Tilemap, xReg:int, yReg:int):void {
			var noise:Vector.<uint>;
			var offsets:Array = new Array();
			for (var count:int = 0; count < numOctaves; count++) 
			{
				var point:Point = new Point(width * xReg, height * yReg);
				point.x += (Point)(timeOffsets[count]).x;
				point.y += (Point)(timeOffsets[count]).y;
				offsets.push(point);
			}
			noise = NoiseVector.createNoiseVector(width, height, width * 0.5, height * 0.5, numOctaves, 100, seed, 0, offsets);
			//generate procedural terrain as such
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var id:int;
					var noiseValue:uint = noise[i + j * width];
					id = getTile(noiseValue);
					tiles.setTile(i, j, id);
				}
			}
		}
		
		//number is between 0 and 255
		private function getTile(noiseValue:uint):int
		{
			if (noiseValue < 92) return 0; //ocean
			else if (noiseValue < 102) return 1; //dirt
			else if (noiseValue < 153) return 2; //grass
			else if (noiseValue < 163) return 3; //stone
			else return 4; //mountain
		}
	}

}