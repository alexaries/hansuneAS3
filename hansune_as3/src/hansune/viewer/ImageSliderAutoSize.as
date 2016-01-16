package hansune.viewer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import hansune.motion.SooTween;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */

	/**
	 * 보이는 크기가 변할 때 이벤트 발생
	 */
	[Event(name = "change", type = "flash.events.Event")]
	/**
	 * 애니메이션이 끝났을 때 이벤트 발생
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class ImageSliderAutoSize extends Sprite
	{
		private var _imageA:Bitmap;
		private var _imageB:Bitmap;
		private var _whiteBack:Sprite;
		private var _isIng:Boolean;
		private var _viewWidth:uint;
		private var _viewHeight:uint;
		private var _mask:Shape;
		private var _current:String;
		private var _change:String;
		private var _dir:String;
		/**
		 * ImageSliderAutoSize 생성
		 * @param	viewWidth 기본 가로 크기
		 * @param	viewHeight 기본 세로 크기
		 */
		public function ImageSliderAutoSize(viewWidth:int=330, viewHeight:int=690)
		{
			_isIng = false;
			//이미지가 보여지는 영역
			_viewWidth = viewWidth;
			_viewHeight = viewHeight;
			
			_whiteBack = new Sprite();
			_whiteBack.graphics.beginFill(0xffffff);
			_whiteBack.graphics.drawRect(0, 0, viewWidth, viewHeight);
			_whiteBack.graphics.endFill();
			addChild(_whiteBack);
			
			var bmd:BitmapData = new BitmapData(_viewWidth, _viewHeight, false, 0xffffff);
			_imageA = new Bitmap(bmd);
			_imageB = new Bitmap(bmd);
			addChild(_imageA);
			_imageB.x = _viewWidth;
			addChild(_imageB);
			_current = "A";
		}
		/**
		 * 현재 이미지를 새로 생성하여 반환
		 * @return
		 */
		public function getCurrentNewImage():Bitmap {
			if (_isIng) return null;
			var bmd:BitmapData = (this["_image" + _current] as Bitmap).bitmapData;
			var bitmap:Bitmap = new Bitmap(bmd.clone());
			return bitmap;// this["_image" + _current];
		}
		/**
		 * 보여지고 있는 가로 크기
		 * @return
		 */
		public function getViewWidth():uint {
			return _whiteBack.width;
		}
		
		/**
		 * 보여지고 있는 세로 크기
		 * @return
		 */
		public function getViewHeight():uint {
			return _whiteBack.height;
		}
		
		/**
		 * 오른쪽에서 왼쪽으로 움직임을 주며 이미지 보여줌
		 * @param	url 불러올 이미지 경로
		 */
		public function next(url:String):void {
			_dir = "next";
			_load(url);
		}
		
		/**
		 * 왼쪽에서 오른쪽으로 움직임을 주며 이미지 보여줌
		 * @param	url 불러올 이미지 경로
		 */
		public function prev(url:String):void {
			_dir = "prev";
			_load(url);
		}
		
		/**
		 * 모션을 중지하고, 이미지를 데이터를 지움.
		 */
		
		public function release():void {
			_isIng = false;
			removeEventListener(Event.ENTER_FRAME, _changeMotion);
			_imageA.bitmapData.dispose();
			_imageB.bitmapData.dispose();
			
		}
		
		private function _load(url:String):void {
			if (!_isIng) {
				_isIng = true;
				
				var imgLoader:Loader = new Loader();
				var request:URLRequest = new URLRequest(url);
				imgLoader.load(request);
				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErr);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,_imgView);
			}
		}
		
		private function _ioErr(e:IOErrorEvent):void{
			trace(e.text);
		}
		
		private function _imgView(event:Event):void {
			
			var jpg:Bitmap = Bitmap(event.target.loader.content);
			
			_viewWidth = jpg.width / 2;
			_viewHeight = jpg.height / 2;
			
			if (_current == "A") {
				_imageB.bitmapData = jpg.bitmapData.clone();
				_imageB.scaleX = 0.5;
				_imageB.scaleY = 0.5;
				_imageB.alpha = 1;
				_change = "B";
				
				if (_dir == "next") {
					_imageB.x = _viewWidth;
				} else {
					_imageB.x = -(_viewWidth);
				}
				
			} else {
				_imageA.bitmapData = jpg.bitmapData.clone();
				_imageA.scaleX = 0.5;
				_imageA.scaleY = 0.5;
				_imageA.alpha = 1;
				_change = "A";
				
				if (_dir == "next") {
					_imageA.x = _viewWidth;
				} else {
					_imageA.x = -(_viewWidth);
				}
			}
			
			SooTween.alphaTo(this["_image" + _current], 0, 0.2);
			SooTween.sizeTo(_whiteBack, _viewWidth, _viewHeight, 0.3, _playSlide, null, null, {onUpdate:_update});			
			jpg.bitmapData.dispose();
		}
		
		private function _update():void {
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function _playSlide():void {
			addEventListener(Event.ENTER_FRAME, _changeMotion);
		}
		
		private function _changeMotion(e:Event):void {
			if (_dir == "next") {
				this["_image" + _current].x += ( ( -_viewWidth) - this["_image" + _current].x) * 0.2;
			} else {
				this["_image" + _current].x += ( (_viewWidth) - this["_image" + _current].x) * 0.2;
			}
			
			this["_image" + _change].x += ( 0 - this["_image" + _change].x) * 0.2;
			
			if (Math.abs( 0 - this["_image" + _change].x) < 1 ) {
				removeEventListener(Event.ENTER_FRAME, _changeMotion);
				this["_image" + _change].x = 0;
				this["_image" + _current].x = (_dir == "next") ? ( -_viewWidth):_viewWidth;
				_current = _change;
				_isIng = false;
				dispatchEvent(new Event(Event.COMPLETE));
				//trace("_isIng false");
				
			}
		}
	}
}