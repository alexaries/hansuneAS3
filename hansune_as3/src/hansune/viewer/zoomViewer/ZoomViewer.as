package hansune.viewer.zoomViewer
{
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import hansune.loader.BitmapLoader;
	import hansune.ui.ScrollBar;
	import hansune.ui.ScrollBarStyle;
	import hansune.utils.scaleByAnchor;
	
	public class ZoomViewer extends Sprite {
		
		private var _file:String;
		private var _viewRect:Rectangle = new Rectangle(0, 0, 400, 400);
		private var _image:Sprite;
		private var _mask:Shape;
		private var _scrollbarV:ScrollBar;
		private var _scrollbarH:ScrollBar;
		private var _zoomUI:ZoomUI;
		
		private var _mouseAtDown:Point = new Point();
		private var _imageXYatDown:Point = new Point();
		private var _isDown:Boolean = false;
		private var _isZooming:Boolean = false;
		private var _currentZoom:Number = 1.0;
		
		//외부 제어를 위한 것
		public var inputX:Number, inputY:Number;
		private var _isExternalInput:Boolean = false;
		
		public function set file(val:String):void { _file = val; }
		public function get file():String { return _file; }
		public function set viewedRectangle(val:Rectangle):void{_viewRect = val;}
		public function get viewedRectangle():Rectangle{ return _viewRect;}
		
		public function ZoomViewer() {}
		
		public function start():void {
			if (_file == null) throw Error("file 값이 없습니다");
			var loader:BitmapLoader = new BitmapLoader();
			loader.addEventListener(Event.COMPLETE, _onload);
			loader.load(_file);
		}
		
		public function end():void { 
			_removeC();
		}
		
		private function _addC():void {
			_image.addEventListener(MouseEvent.MOUSE_DOWN, _down);
			_image.addEventListener(MouseEvent.MOUSE_MOVE, movePage);
			_image.addEventListener(MouseEvent.MOUSE_UP, _up);
			_image.addEventListener(MouseEvent.MOUSE_OUT, _out);
			this.addEventListener(Event.ENTER_FRAME, _onCount);
		}
		
		private function _removeC():void {
			_image.removeEventListener(MouseEvent.MOUSE_DOWN, _down);
			_image.removeEventListener(MouseEvent.MOUSE_MOVE, movePage);
			_image.removeEventListener(MouseEvent.MOUSE_UP, _up);
			_image.removeEventListener(MouseEvent.MOUSE_OUT, _out);
			this.removeEventListener(Event.ENTER_FRAME, _onCount);
		}
		
		private function _onload(e:Event):void {
			_image = new Sprite();
			_image.addChild((e.target as BitmapLoader).bitmap);
			
			var scale:Number = Math.min(_viewRect.width / _image.width, _viewRect.height / _image.height);
			
			_image.scaleX = scale;
			_image.scaleY = scale;
			_image.x = _viewRect.left + ((_viewRect.width - _image.width) >> 1) >> 0;
			_image.y = _viewRect.top + ((_viewRect.height - _image.height) >> 1) >> 0;;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, _viewRect.width, _viewRect.height);
			_mask.graphics.endFill();
			_mask.x = _viewRect.x;
			_mask.y = _viewRect.y;
			
			addChildAt(_image, 0);
			addChildAt(_mask, 1);
			_image.mask = _mask;
			
			_scrollbarV = new ScrollBar(_viewRect.height, _image.height, ScrollBarStyle.VERTICAL);
			_scrollbarV.x = _viewRect.right - 5;//_scrollbarV width : 5
			_scrollbarV.y = _viewRect.y;
			_scrollbarV.start();
			addChild(_scrollbarV);
			
			_scrollbarH = new ScrollBar(_viewRect.width - 5, _image.width, ScrollBarStyle.HORIZON);
			_scrollbarH.x = _viewRect.left;
			_scrollbarH.y = _viewRect.bottom - 5;//_scrollbarH height 5
			_scrollbarH.start();
			addChild(_scrollbarH);
			
			_zoomUI = new ZoomUI();
			_zoomUI.viewRect = _viewRect;
			_zoomUI.zoomMin = scale;
			_zoomUI.zoomMax = 3.0;
			addChild(_zoomUI);
			
			_currentZoom = scale;
			_imageXYatDown.x = _image.x;
			_imageXYatDown.y = _image.y;
			
			_addC();
			
		}
		
		private var _count:uint;
		private function _down(e:MouseEvent):void {
			_mouseAtDown.x = mouseX;
			_mouseAtDown.y = mouseY;
			_imageXYatDown.x = _image.x;
			_imageXYatDown.y = _image.y;
			_count = 0;
			_isDown = true;
		}
		
		
		public function movePage(e:MouseEvent = null):void {
			if (_isDown && !_isZooming) {
				if((_image.x <= _viewRect.x) && (_image.x >= _viewRect.width - _image.width + _viewRect.x)){
					_image.x = (_imageXYatDown.x + (mouseX - _mouseAtDown.x));
					_scrollbarH.position = Math.abs(_image.x - _viewRect.x) / Math.abs(Math.min(0, _viewRect.width - _image.width));
				}
				if((_image.y <= _viewRect.y) && (_image.y >= _viewRect.height - _image.height + _viewRect.y)){
					_image.y = (_imageXYatDown.y + (mouseY - _mouseAtDown.y));
					_scrollbarV.position = Math.abs(_image.y - _viewRect.y) / Math.abs(Math.min(0, _viewRect.height - _image.height));
				}
			}
			
			if (_isZooming) {
				if (_isExternalInput) {
					_zoomUI.addBy(inputX, inputY);
				} else {
					_zoomUI.addBy(mouseX, mouseY);
				}
				
				scaleByAnchor(_image, _mouseAtDown,_zoomUI.getRate(),_zoomUI.getRate());
				_currentZoom = _image.scaleX;
				_scrollbarH.targetLength = _image.width;
				_scrollbarV.targetLength = _image.height;
				
				_arrenge();
			}
		}
		
		private function _up(e:MouseEvent):void {
			_isDown = false;
			_isZooming = false;
			_currentZoom = _zoomUI.getRate();
			_zoomUI.visible = false;
			_arrenge();
		}
		
		private function _out(e:MouseEvent):void {
			_isDown = false;
			_isZooming = false;
			_currentZoom = _zoomUI.getRate();
			_zoomUI.visible = false;
			_arrenge();
		}
		
		private function _arrenge():void {
			//trace("_image.width " + _image.width +"/ _image.height " + _image.height);
			//trace("_viewRect.width " + _viewRect.width +"/ _viewRect.height " + _viewRect.height);
			//trace(_isZooming);
			if(_image.width < _viewRect.width){
				_image.x = _viewRect.left + ((_viewRect.width - _image.width) >> 1) >> 0;
				_image.y = _viewRect.top + ((_viewRect.height - _image.height) >> 1) >> 0;;
			} else {
				if (_image.x > _viewRect.x) _image.x = _viewRect.x;
				if (_image.x < _viewRect.width - _image.width + _viewRect.x) _image.x = _viewRect.width - _image.width + _viewRect.x;
				if (_image.y > _viewRect.y) _image.y = _viewRect.y;
				if (_image.y < _viewRect.height - _image.height + _viewRect.y) _image.y = _viewRect.height - _image.height + _viewRect.y;
			}
		}
		
		
		private function _onCount(e:Event):void {
			if (_isDown && !_isZooming) {
				_count ++;
				if (_count > 20 && !_isZooming && Math.abs(_mouseAtDown.x - mouseX) < 5 && Math.abs(_mouseAtDown.y -mouseY) < 5) {
					_isZooming = true;
					_zoomUI.visible = true;
					_zoomUI.startAt(mouseX, mouseY, _currentZoom);
				}
			}
		}
		
		/**
		 * 마우스 입력 없이 줌 기능을 조작하고자 할때
		 * 시뮬레이션 할때 필요한 것들
		 * 
		 * externalInputView 외부입력 모드로 전환
		 * externalInputHide 외부입력 모드 해제
		 * externalZoomUIstartAt 외부입력 시작할 때 시작위치 지정
		 * externalPosAtDown 마우스 입력과 같이 위치를 전달한다.
		 */
		
		public function externalInputView():void {
			_isExternalInput = true;
			_isZooming = true;
		}
		
		public function externalInputHide():void {
			_isExternalInput = false;
			_isZooming = false;
			_zoomUI.visible = false;
			_addC();
		}
		
		public function externalZoomUIstartAt(hx:Number, hy:Number):void {
			_zoomUI.visible = true;
			_zoomUI.startAt(hx, hy, _currentZoom);
		}
		
		public function externalPosAtDown(hx:Number, hy:Number):void {
			_mouseAtDown.x = hx;
			_mouseAtDown.y = hy;
		}
		
	}
	
}