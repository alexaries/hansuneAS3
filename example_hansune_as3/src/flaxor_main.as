//
// Flaxor (989bytes effect)
// by Mr.doob
//
// Thanks to Texel (http://www.romancortes.com/) and Forrest Briggs (http://laserpirate.com/flashblog/)
//

package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(backgroundColor = "#000000", frameRate = "50")]
	public class flaxor_main extends Sprite
	{
		public var bitmap : Bitmap, canvas : BitmapData;
		public var sw : int, sh : int, mx : Number, my : Number, timer:int = 0;
		
		public function flaxor_main()
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.addEventListener("resize", init);
			
			init(null);
			
			addEventListener("enterFrame", loop);
		}	
		
		public function init(e:Event) : void
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			canvas = new BitmapData(sw, sh, false);
			
			bitmap = new Bitmap(canvas);
			
			if (contains(bitmap))
				removeChild(bitmap);
			
			addChild(bitmap);
		}
		
		public function loop(e:Event):void
		{
			canvas.lock();
			
			for (var xx:int = 0; xx < sw; xx++)
				for (var yy:int = 0; yy < sh; yy++)				
					canvas.setPixel(xx, yy, (xx + timer ^ yy + timer) * timer);
			
			canvas.unlock();
			timer++;
		}	
	}
}
