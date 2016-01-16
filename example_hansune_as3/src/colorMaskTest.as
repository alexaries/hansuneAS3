package
{
	import hansune.loader.BitmapLoader;
	import hansune.gl.bitmapScaleToHalf;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class colorMaskTest extends Sprite
	{
		public function colorMaskTest()
		{
			var loader:BitmapLoader = new BitmapLoader();
			loader.addEventListener(Event.COMPLETE, _onload);
			loader.load("../data/kim.jpg");
		}
		
		private function _onload(e:Event):void{
			var bm:Bitmap = (e.target as BitmapLoader).bitmap;
			addChild(bm);
			
			var greenValueToMatch:Number = 0x00;
			var colorMask:Number = 0x0000ff00;
			var masked:Bitmap = new Bitmap(bm.bitmapData.clone());
			var rect:Rectangle = masked.bitmapData.getColorBoundsRect(colorMask, greenValueToMatch << 8 );
			var redMask:Number = 0x00ff0000;
			var pt:Point = new Point(rect.x, rect.y);
			masked.bitmapData.threshold(masked.bitmapData, rect, pt, ">", 0x99 << 16, 0xffffffff, redMask, true);
			masked.x = bm.width;
			addChild(masked);
			
			var rectDraw:Shape = new Shape();
			rectDraw.graphics.lineStyle(1, 0xff << 16);
			rectDraw.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			rectDraw.graphics.endFill();
			rectDraw.x = masked.x;
			addChild(rectDraw);
			
		}
	}
}