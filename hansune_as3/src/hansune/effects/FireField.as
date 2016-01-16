package hansune.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import hansune.Hansune;

	public class FireField extends Sprite
	{
		private var _perlinBM:Bitmap;
		private var _perlinBD:BitmapData;
		private var _perlinScrollBD:BitmapData;
		private var _canvas:Sprite;		
		private var _canvasBM:Bitmap;
		private var _canvasBD:BitmapData;
		
		private var _fieldWidth:uint;
		private var _fieldHeight:uint;
		
		public var fireSpeed:uint = 4;
		private var _sampling:uint = 4;
		private var matrix:Matrix;
		
		public function get sampling():uint {
			return _sampling;
		}
		
		public function FireField(w:uint, h:uint, sampling:uint = 4)
		{
			Hansune.copyright();
			
			_sampling = sampling;
			_fieldWidth = w;
			_fieldHeight = h;
			
			_perlinScrollBD = new BitmapData(_fieldWidth/_sampling, fireSpeed, false, 0);
			
			_canvasBD = new BitmapData(_fieldWidth/_sampling, _fieldHeight/_sampling, true, 0);
			_canvasBM = new Bitmap(_canvasBD);
			_canvasBM.scaleX = _sampling;
			_canvasBM.scaleY = _sampling;
			addChild(_canvasBM);
			
			_perlinBD = new BitmapData(_fieldWidth/_sampling, _fieldHeight/_sampling, false, 0);
			_perlinBD.perlinNoise(20, 40, 10, 0, true, true, 7, true);
			_perlinBM = new Bitmap(_perlinBD);
			_perlinBM.blendMode = BlendMode.OVERLAY;
			_perlinBM.scaleX = _sampling;
			_perlinBM.scaleY = _sampling;
			addChild(_perlinBM);
			
			matrix = new Matrix();
			matrix.scale(1/_sampling, 1/_sampling);
			
			_canvas = new Sprite();
			addChild(_canvas);
			
		}
		
		public function addObject(child:DisplayObject) : DisplayObject {
			addEventListener(Event.ENTER_FRAME, _render);
			return _canvas.addChild(child);
		}
		
		public function addObjectAt(child:DisplayObject, index:int) : DisplayObject {
			addEventListener(Event.ENTER_FRAME, _render);
			return _canvas.addChildAt(child, index);
		}
		
		public function removeObject(child:DisplayObject) : DisplayObject {
			if(_canvas.numChildren == 1 && _canvas.contains(child)) removeEventListener(Event.ENTER_FRAME, _render);
			return _canvas.removeChild(child);
		}
		
		public function removeObjectAt(index:int) : DisplayObject {
			if(_canvas.numChildren == 1 && _canvas.getChildAt(index)) removeEventListener(Event.ENTER_FRAME, _render);
			return _canvas.removeChildAt(index);
		}
		
		private var blur:BlurFilter = new BlurFilter(2,2,1);
		private var nP:Point = new Point();
		private var colorTrans:ColorTransform = new ColorTransform(1, 1, .5, 0.98, -5, -20, -20);
		
		private function _render(e:Event):void 
		{
			_canvasBD.draw(_canvas, matrix);
			_canvasBD.applyFilter(_canvasBD, _canvasBD.rect, nP, blur);
			_canvasBD.colorTransform(_canvasBD.rect, colorTrans);
			_canvasBD.scroll(0, -1);
			
			_perlinScrollBD.copyPixels(_perlinBD, new Rectangle(0, 0, _fieldWidth/_sampling, fireSpeed), nP);
			_perlinBD.scroll(0, -fireSpeed);
			_perlinBD.copyPixels(_perlinScrollBD, _perlinScrollBD.rect, new Point(0, _fieldHeight/_sampling - fireSpeed));
		}
	}
}