//------------------------------------------------------------------------------
//
//   Apache License 2.0
//   hansune.com All rights reserved. 
//
//------------------------------------------------------------------------------

package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class curveLineTest extends Sprite
	{
		
		public function curveLineTest()
		{
			bmd = new BitmapData(stage.stageWidth/2, stage.stageHeight/2, false, 0xff000000);
			
			filter = new BlurFilter(3, 3, 3);
			
			var matrix:Array = new Array();
			matrix = matrix.concat([0.99, 0, 0.01, 0, 0]);// red
			matrix = matrix.concat([0.01, 0.99, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0.01, 0.98, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 0.88, 0]);// alpha
			filter1 = new ColorMatrixFilter(matrix);
			
			bm = new Bitmap(bmd);
			bm.scaleX = 2.0;
			bm.scaleY = 2.0;
			addChild(bm);
			
			spot = new Array();
			for(var i:uint = 0; i<20; ++i){
				spot[i] = new Point(Math.random()*512,Math.random()*384);
			}
			canvas = new Shape();
			addEventListener(Event.ENTER_FRAME, onRender);
			
			//onRender();
		}

		private var bm:Bitmap;
		private var bmd:BitmapData;
		private var canvas:Shape;
		private var filter:BlurFilter;
		private var filter1:BitmapFilter;
		private var spot:Array;
		
		private function onRender(e:Event = null):void
		{
			canvas.graphics.lineStyle(1,0xffee00, 1.0);
			
			spot[0].x = mouseX / 2;
			spot[0].y = mouseY / 2;
			
			spot.unshift(new Point(mouseX /2, mouseY /2));
			spot.pop();
			
			canvas.graphics.moveTo(mouseX /2, mouseY /2);
			for(var i:uint=0; i<19; i ++){
				canvas.graphics.curveTo(spot[i].x, spot[i].y, spot[i+1].x, spot[i+1].y);
				i ++;
			}
			
			bmd.draw(canvas);
			//bmd.applyFilter(bmd, new Rectangle(0,0,bm.width, bm.height), new Point(), filter);
			bmd.applyFilter(bmd, new Rectangle(0,0,bm.width, bm.height), new Point(), filter1);
			
			canvas.graphics.clear();

		}
	}
}
