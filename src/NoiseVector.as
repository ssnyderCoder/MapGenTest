package  
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	/**
	 * This function basically just creates a 1px high bitmap (width defined as the length of the vector),
	 * initiates grayscale Perlin noise in that bitmap, optionally applies a blur,
	 * and then scales the values according to the scale function argument.

	 * The scaling is done by first calculating the average value (using just the blue channel,
	 * since all channels will be identical due to the noise being grayscale.)
	 * The values are then normalized between -1 and 1, where the average will be 0,
	 * and scaled by the supplied scale factor.

	 * The function can then be used in the following way, to retrieve 1000 values:
	 * 
	 * _noise = new Vector.<Number>(1000, true);
	 * PerlinNoiseUtil.initNoiseVector(_noise, 300, 10, randomDev * periodTime, 10);
	 * 
	 * Hope this helps!
	 * @author Richard Olsson
	 */
	public class NoiseVector 
	{
		
		/**
		 * Created by richardolsson on gamedev.stackexchange. (Modified by me)
		 * @param	width
		 * @param	height
		 * @param	baseX x frequency; generally set equal or less than length of width
		 * @param	baseY y frequency; generally set equal or less than length of height
		 * @param	numOctaves number of individual noise functions used to create vector.
		 * @param	scale scales the values
		 * @param	seed seed value used for psuedo random values.
		 * @param	blur applies a blur if used
		 * @param	offsets offset for each octave
		 * @return vector containing values ranging from -1 to 1
		 */
		public static function createNoiseVector(width:uint, height:uint, baseX : Number, 
			baseY : Number, numOctaves : Number, scale : Number, seed:int = 0, blur : uint = 0, offsets:Array = null) : Vector.<uint>
		{
			var len : uint = width * height;
			var perlin : BitmapData;
			var noise : Vector.<uint>;
			var output : Vector.<uint> = new Vector.<uint>(len, true);

			perlin = new BitmapData(width, height);
			perlin.perlinNoise(baseX, baseY, numOctaves, seed, false, true, 7, true, offsets);

			if (blur > 0)
				perlin.applyFilter(perlin, perlin.rect, new Point(), new BlurFilter(blur, blur, 3));

			noise = perlin.getVector(perlin.rect);

			var i : uint;
			for (i=0; i<len; i++) {
				output[i] = noise[i]&0xff
			}
			return output;
		}
		
	}

}