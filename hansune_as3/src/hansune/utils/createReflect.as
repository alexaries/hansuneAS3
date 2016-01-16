package hansune.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */
		
	public function createReflect(source:DisplayObject, latitude:uint):Bitmap
	{
		var bmd:BitmapData = new BitmapData(source.width, source.width);
		var bmdWidth:uint = bmd.width;
		
		var rgb:uint;
		var r:uint;
		var g:uint;
		var b:uint;
		var a:uint;
		var color:uint;
		var count:uint = 0;
		var add:Number = 255 / latitude;
		
		bmd.draw(source, null, null, null, new Rectangle(0, source.height - latitude, source.width, latitude), false);
		bmd.scroll(0, -(source.height - latitude));
		
		var n_bmd:BitmapData = new BitmapData(bmdWidth, latitude, true, 0x00000000);
		
		for (var yy:uint = latitude; yy > 0; --yy) {
			count += add;
			for (var xx:uint = 0; xx <= bmdWidth; ++xx) {
				rgb = bmd.getPixel32(xx, yy);
				r = rgb >> 16 & 0xFF;
				g = rgb >> 8 & 0xFF;
				b = rgb & 0xFF;
				a = 255 - count;
				color = (a << 24) | (r << 16) | (g << 8) | (b);
				n_bmd.setPixel32(xx, count, color);
			}
		}
		
		return new Bitmap(n_bmd);
		
	}
}