package hansune.viewer
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import hansune.Hansune;
	import hansune.motion.SooTween;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */
	public class ImageViewer extends Sprite
	{
		
		/**
		 * 블라인드로 가려지는 컨테이너 크기
		 */
		public var containerWidth:uint = 1024;
		public var containerHeight:uint = 768;
		/**
		 * 시작할 때 보여줄 이미지 위치(0.0 ~ 1.0)
		 */
		public var initPosition:Number = 0;
		
		private const TOP_MARGIN:uint = 30;
		private const BOTTOM_MARGIN:uint = 30;
		
		private var _source:Bitmap;
		private var _imageWidth:uint;
		private var _imageHeight:uint;
		private var _blind:Sprite;
		private var _image:Sprite;
		private var _blurFilter:Array;
		private var _xBt:Sprite;
		
		public function ImageViewer() 
		{
			Hansune.copyright();
		}
		
		private function _getBlind():Sprite {
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(0x000000, 0.3);
			shape.graphics.drawRect(0, 0, containerWidth, containerHeight);
			shape.graphics.endFill();
			return shape;
		}
		
		private function _getXbt():Sprite {
			var sp:Sprite = new Sprite();
			
			 var commands:Vector.<int> = new Vector.<int>(4, true);
			commands[0] = 1;
			commands[1] = 2;
			commands[2] = 2;
			commands[3] = 2;
			var coord:Vector.<Number> = new Vector.<Number>(8, true);
			coord[0] = 0; //x
			coord[1] = 0; //y 
			coord[2] = 50; 
			coord[3] = 0; 
			coord[4] = 50; 
			coord[5] = 50; 
			coord[6] = 0; 
			coord[7] = 50;
			sp.graphics.beginFill(0, 0.3);
			sp.graphics.drawPath(commands, coord);
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0xffffff, 1);
			line.graphics.moveTo(10, 10);
			line.graphics.lineTo(40, 40);
			line.graphics.moveTo(10, 40);
			line.graphics.lineTo(40, 10);
			
			sp.addChild(line);
			
			return sp;
		}
		
		public function view(bitmap:Bitmap):void {
			_source = bitmap;
			_source.scaleX = 1.0;
			_source.scaleY = 1.0;
			
			if (_image == null) _image = new Sprite();
			if (_blurFilter == null) {
				var filter:GlowFilter = new GlowFilter(0x000000, 0.5, 15, 15, 1);
				_blurFilter = new Array(filter);
			}
			
			_image.filters = _blurFilter;
			_image.addChild(_source);
			_image.x = (containerWidth - _source.width) / 2;
			_image.y = (containerHeight - _source.height) / 2;
			_image.alpha = 0;
			
			_imageWidth = bitmap.width;
			_imageHeight = bitmap.height;
			
			if (_blind == null) _blind = _getBlind();
			
			_blind.alpha = 0;
			_blind.visible = true;	
			
			if (_xBt == null) _xBt = _getXbt();
			_xBt.x = _image.x + _image.width;
			_xBt.y = TOP_MARGIN;
			if (_xBt.x + _xBt.width > containerWidth) _xBt.x = containerWidth - _xBt.width;
			
			addChild(_blind);
			addChild(_image);
			addChild(_xBt);
			addEventListener(Event.ENTER_FRAME, _imageAlphaIn);
			
		}
		
		public function hide():void {
			_image.removeChild(_source);
			removeChild(_xBt);
			removeChild(_image);
			_source.bitmapData.dispose();
			_source = null;
			_naviDel();
			addEventListener(Event.ENTER_FRAME, _imageAlphaOut);
		}
		
		private function _imageAlphaIn(e:Event):void {
			_blind.alpha += 0.1;
			_image.alpha += 0.1;
			if (_image.alpha > 0.95) {
				removeEventListener(Event.ENTER_FRAME, _imageAlphaIn);
				//trace(_imageHeight + " / " + containerHeight);
				if (_imageHeight > containerHeight) {
					//moveTo(_image, _image.x, Math.max(TOP_MARGIN - initPosition * _imageHeight, containerHeight - BOTTOM_MARGIN - _imageHeight),0.2, _naviAdd );
					SooTween.moveTo(_image,  _image.x,Math.max(TOP_MARGIN - initPosition * _imageHeight, containerHeight - BOTTOM_MARGIN - _imageHeight),0.2, null , _naviAdd);
				}
				else {
					_naviAdd();
				}
				
			}
		}
		
		private function _imageAlphaOut(e:Event):void {
			_blind.alpha -= 0.1;
			if (_blind.alpha < 0.05) {
				removeEventListener(Event.ENTER_FRAME, _imageAlphaOut);
				removeChild(_blind);
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function _naviAdd():void {
			_image.addEventListener(MouseEvent.MOUSE_DOWN, _imageDown);
			_blind.addEventListener(MouseEvent.CLICK, _blindClick);
			_xBt.addEventListener(MouseEvent.CLICK, _xBtClick);
			this.addEventListener(MouseEvent.MOUSE_MOVE, _imageMove);
			this.addEventListener(MouseEvent.MOUSE_UP, _imageUp);
			
		}
		
		private function _naviDel():void {
			
			_image.removeEventListener(MouseEvent.MOUSE_DOWN, _imageDown);
			_blind.removeEventListener(MouseEvent.CLICK, _blindClick);
			_xBt.removeEventListener(MouseEvent.CLICK, _xBtClick);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, _imageMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, _imageUp);
			
		}
		
		private var _isDown:Boolean = false;
		private var _my:Number;
		private var _gy:Number;
		
		private function _imageDown(e:MouseEvent):void {
			_my = mouseY;
			_gy = _image.y;
			_isDown = true;
		}
		
		private function _imageUp(e:MouseEvent):void {
			_isDown = false;
			if (_imageHeight > containerHeight) {
				if (_image.y > TOP_MARGIN) _image.y = TOP_MARGIN;
				if (_image.y < (containerHeight - BOTTOM_MARGIN - _imageHeight)) _image.y = (containerHeight - BOTTOM_MARGIN - _imageHeight);
			}
		}
		
		private function _imageMove(e:MouseEvent):void {
			if (_isDown) {
				if (_imageHeight > containerHeight) {
					if (_image.y <= TOP_MARGIN && _image.y >= (containerHeight - BOTTOM_MARGIN - _imageHeight)) {
						_image.y = _gy + (mouseY - _my);
					}
				}
			}
		}
		
		private function _blindClick(e:MouseEvent):void {
			hide();
		}
		
		private function _xBtClick(e:MouseEvent):void {
			hide();
		}
	}
	
}