// ActionScript file
package hansune.gl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */		
	public function bitmapScaleToHalf(source:Bitmap):Bitmap
	{
		var x:int, y:int, x2:int, y2:int;
		var tgWidth:int, tgHeight:int;
		var sourceBmd:BitmapData;
		var outBmd:BitmapData;
		var pixelA:uint;
		var pixelB:uint;
		
		tgWidth = int(source.width / 2);
		tgHeight = int(source.height / 2);
		outBmd = new BitmapData(tgWidth, tgHeight);
		
		sourceBmd = source.bitmapData;
		
		for (y = 0; y < tgHeight; ++y) 
		{
			y2 = y * 2;
			for (x = 0; x < tgWidth; ++x) {
				x2 = x * 2;
				pixelA = averagePixel32(sourceBmd.getPixel32(x2, y2), sourceBmd.getPixel32(x2 + 1, y2));
				pixelB = averagePixel32(sourceBmd.getPixel32(x2, y2 + 1), sourceBmd.getPixel32(x2 + 1, y2 + 1));
				outBmd.setPixel32(x, y, averagePixel32(pixelA, pixelB));
			}
		}
		
		return new Bitmap(outBmd);
	}
}