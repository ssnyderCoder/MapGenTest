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
		private var numOctaves:int = 2;
		public function MapGen(width:int, height:int, seed:int) 
		{
			this.width = width;
			this.height = height;
			this.seed = seed;
		}
		
		public function generateTerrain(xReg:int, yReg:int):Vector.<uint> {
			var noise:Vector.<uint>;
			var offsets:Array = new Array();
			for (var count:int = 0; count < numOctaves; count++) 
			{
				var point:Point = new Point(width * xReg, height * yReg);
				offsets.push(point);
			}
			noise = NoiseVector.createNoiseVector(width, height, width * 1, height * 1, numOctaves, 100, seed, 0, offsets);
			//generate procedural terrain as such
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var id:int;
					var noiseValue:uint = noise[i + j * width];
					id = getTile(noiseValue);
					noise[i + j * width] = id;
				}
			}
			return noise;
		}
		
		public function generateNoise(x:int, y:int):Vector.<uint> {
			var noise:Vector.<uint>;
			var offsets:Array = new Array();
			for (var count:int = 0; count < numOctaves; count++) 
			{
				var point:Point = new Point(width * x, height * y);
				offsets.push(point);
			}
			noise = NoiseVector.createNoiseVector(width, height, width * 1, height * 1, numOctaves, 100, seed, 0, offsets);
			return noise;
		}
		
		//number is between 0 and 255
		private function getTile(noiseValue:uint):int
		{
			if (noiseValue < 55) return 0; //ocean
			else if (noiseValue < 75) return 1; //dirt
			else if (noiseValue < 150) return 2; //grass
			else if (noiseValue < 185) return 3; //stone
			else return 4; //mountain
		}
	}

}