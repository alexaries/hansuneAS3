package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import hansune.loader.BitmapLoader;
	import hansune.viewer.ImageViewer;
	
	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='60')]
	public class bitmapLoaderEx extends Sprite
	{
		private var loader:BitmapLoader;

		
		public function bitmapLoaderEx()
		{
			loader = new BitmapLoader();
			loader.addEventListener(Event.COMPLETE, _onLoad);
			loader.load("../data/kim.jpg");
		}
		
		private function _onLoad(e:Event):void{
			var bm:Bitmap = (e.target as BitmapLoader).bitmap;
			addChild(bm);
			
			var bmd:BitmapData = new BitmapData(bm.width, bm.height);
			var mat:Matrix = new Matrix();
			//mat.translate(0, -100);
			bmd.draw(bm, mat, null, null, new Rectangle(0, 100, bm.width, bm.height - 100));
			var newbmd:BitmapData = new BitmapData(bm.width, bm.height - 100);
			newbmd.copyPixels(bmd, new Rectangle(0, 100, bm.width, bm.height - 100), new Point(0,0));
			//bmd.scroll(0, -100);
			var nbm:Bitmap = new Bitmap(newbmd);
			nbm.x = bm.width;
			addChild(nbm);
			
			///* 
//			var im:ImageViewer;
//			im = new ImageViewer();
//			im.containerWidth = 800;
//			im.containerHeight = 600;
//			im.initPosition = 0;
//			im.view(bm);
//			addChild(im);
			//*/
		}

	}
}