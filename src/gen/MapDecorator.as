package gen
{
	import net.flashpunk.FP;
	/**
	 * Occurs after terrain generation.  Base class for structure generation onto the overworld.
	 * @author Sean Snyder
	 */
	public class MapDecorator 
	{
		protected var seed:int;
		public function MapDecorator(seed:int) 
		{
			this.seed = seed;
		}
		
		public function generate(mapdata:MapData, xReg:int, yReg:int):void {
			FP.randomSeed = seed;
			const rand1:int = FP.rand(int.MAX_VALUE);
			const rand2:int = FP.rand(int.MAX_VALUE);
			const xSeed:int = xReg * rand1;
			const ySeed:int = yReg * rand2;
			const regSeed:int = xSeed ^ ySeed ^ seed;
			FP.randomSeed = regSeed;
			beginGeneration(xReg, yReg, mapdata);
		}
		
		protected function beginGeneration(xReg:int, yReg:int, mapdata:MapData):void {
			return;
		}
		
	}

}