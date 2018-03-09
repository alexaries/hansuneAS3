package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import hansune.gl.bitmapScaleToHalf;
	import hansune.loader.BitmapLoader;
	
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class bitmapScaleTest extends Sprite
	{
		public function bitmapScaleTest()
		{
			var loader:BitmapLoader = new BitmapLoader();
			loader.addEventListener(Event.COMPLETE, _onload);
			loader.load("data/kim.jpg");
		}
		
		private function _onload(e:Event):void{
			var bm:Bitmap = (e.target as BitmapLoader).bitmap;
			var half:Bitmap = bitmapScaleToHalf(bm);
			addChild(bm);
			half.x = bm.width;
			addChild(half);
			
			var greenValueToMatch:Number = 0x80;
			var colorMask:Number = 0x0000ff00;
			var masked:Bitmap = new Bitmap(bm.bitmapData.clone());
			var rect:Rectangle = masked.bitmapData.getColorBoundsRect(colorMask, greenValueToMatch << 8 );
			var redMask:Number = 0x00ff0000;
			var pt:Point = new Point(0, 0);
			masked.bitmapData.threshold(masked.bitmapData, rect, pt, ">", 0x99 << 16, 0xffffffff, redMask, true);
			masked.y = bm.height;
			addChild(masked);
			
		}
	}
}