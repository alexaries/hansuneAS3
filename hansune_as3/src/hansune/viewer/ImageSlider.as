package hansune.viewer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import hansune.Hansune;
	import hansune.motion.SooTween;
	import hansune.motion.easing.Quadratic;
	import hansune.utils.Log;
	
	/**
	 * Sliding complete event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class ImageSlider extends Sprite
	{
		public static function get className():String {
			return "ImageSlider";
		}
		
		private static const RIGHT:int = 0x01;
		private static const LEFT:int = 0x02;
		private static const JUST:int = 0x03;
		private static const UP:int = 0x04;
		private static const DOWN:int = 0x05;
		
		private var imageA:Bitmap;
		private var imageB:Bitmap;
		private var isIng:Boolean;
		private var viewWidth:uint;
		private var viewHeight:uint;
		private var _mask:Shape;
		private var current:String;
		private var change:String;
		private var direction:int = JUST;
		
		private const container:Sprite = new Sprite();
		private const masking:Shape = new Shape();
		private var tweenShow:SooTween;
		private var tweenHide:SooTween;
		
		/**
		 * ImageSlider Constructor
		 * @param	viewWidth width size to show
		 * @param	viewHeight height size to show
		 */
		
		public function ImageSlider(viewWidth:int=447, viewHeight:int=523)
		{
			Hansune.copyright();
			
			this.isIng = false;
			//이미지가 보여지는 영역
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
			
			masking.graphics.beginFill(0);
			masking.graphics.drawRect(0, 0, viewWidth, viewHeight);
			masking.graphics.endFill();
			
			this.addChild(container);
			this.addChild(masking);
			container.mask = masking;
			
			var bmd:BitmapData = new BitmapData(viewWidth, viewHeight, false, 0x00ffffff);
			this.imageA = new Bitmap(bmd);
			this.imageB = new Bitmap(bmd);
			container.addChild(imageA);
			this.imageB.x = viewWidth;
			container.addChild(imageB);
			
			this.current = "A";
		}
		
		
		/**
		 * Just show the image of url 
		 * @param url url of the image to show
		 * 
		 */
		public function just(url:String):void {
			direction = JUST;
			loadInternal(url);
		}
		
		/**
		 * 오른쪽에서 왼쪽으로 움직임을 주며 이미지 보여줌
		 * @param	url 불러올 이미지 경로
		 */
		public function left(url:String):void {
			direction = LEFT;
			loadInternal(url);
		}
		/**
		 * 왼쪽에서 오른쪽으로 움직임을 주며 이미지 보여줌
		 * @param	url 불러올 이미지 경로
		 */
		
		public function right(url:String):void {
			direction = RIGHT;
			loadInternal(url);
		}
		
		public function up(url:String):void {
			direction = UP;
			loadInternal(url);
		}
		
		public function down(url:String):void {
			direction = DOWN;
			loadInternal(url);
		}
		
		/**
		 * 모션을 중지하고, 이미지를 데이터를 지움.
		 */
		public function release():void {
			isIng = false;
//			removeEventListener(Event.ENTER_FRAME, _changeMotion);
			if(contains(imageA)) removeChild(imageA);
			if(contains(imageB)) removeChild(imageB);
			imageA.bitmapData.dispose();
			imageB.bitmapData.dispose();
			
		}
		
		private function loadInternal(url:String):void {
			if (!isIng) {
				isIng = true;
				var imgLoader:Loader = new Loader();
				var request:URLRequest = new URLRequest(url);
				imgLoader.load(request);
				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadImage);
			}
		}
		
		private function onIoError(e:IOErrorEvent):void{
			Log.e(className, e.toString());
		}
		
		private function beforePosition(dis:DisplayObject):void {
			switch(direction) {
				case LEFT:
					dis.x = viewWidth;
					break;
				case RIGHT:
					dis.x = -viewWidth;
					break;
				case JUST:
					dis.x = 0;
					break;
				case UP:
					dis.y = viewHeight;
					break;
				case DOWN:
					dis.y = -viewHeight;
					break;
			}
		}
		
		private function onLoadImage(event:Event):void {
			var loadedBm:Bitmap = Bitmap(event.target.loader.content);
			if (current == "A") {
				imageB.bitmapData = loadedBm.bitmapData.clone();
				change = "B";
				
//				if (_dir == "next") {
//					_imageB.x = _viewWidth;
//				} else {
//					_imageB.x = -(_viewWidth);
//				}
				beforePosition(imageB);
				
			} else {
				imageA.bitmapData = loadedBm.bitmapData.clone();
				change = "A";
				
//				if (_dir == "next") {
//					_imageA.x = _viewWidth;
//				} else {
//					_imageA.x = -(_viewWidth);
//				}
				beforePosition(imageA);
			}
			
			loadedBm.bitmapData.dispose();
			//addEventListener(Event.ENTER_FRAME, _changeMotion);
			var tx:Number = 0;
			var ty:Number = 0;
			switch(direction) {
				case LEFT:
					tx = -viewWidth;
					break;
				case RIGHT:
					tx = viewWidth;
					break;
				case UP:
					ty = -viewHeight;
					break;
				case DOWN:
					ty = viewHeight;
					break;
			}
			
			if(tweenHide != null && tweenHide.isPlaying) tweenHide.finish();
			tweenHide = SooTween.moveTo(this["image" + current], tx, ty, 1, Quadratic.easeInOut);
//			if (direction == "next") {
//				SooTween.moveTo(this["_image" + _current], ( -_viewWidth), this["_image" + _current].y, 1, Quadratic.easeInOut);
//			} else {
//				SooTween.moveTo(this["_image" + _current], ( _viewWidth), this["_image" + _current].y, 1, Quadratic.easeInOut);
//			}
			container.addChild(this["image" + change]);
			
			if(tweenShow != null && tweenShow.isPlaying) tweenShow.finish();
			tweenShow = SooTween.moveTo(this["image" + change], 0, 0, 0.7, Quadratic.easeInOut, endMotion);
		}
		
		private function endMotion():void {
			current = change;
			isIng = false;
			dispatchEvent(new Event(Event.COMPLETE));
			//Log.d(className, "endMotion");
		}
		
//		private function _changeMotion(e:Event):void {
//			if (_dir == "next") {
//				this["_image" + _current].x += ( ( -_viewWidth) - this["_image" + _current].x) * 0.2;
//			} else {
//				this["_image" + _current].x += ( (_viewWidth) - this["_image" + _current].x) * 0.2;
//			}
//			
//			this["_image" + _change].x += ( 0 - this["_image" + _change].x) * 0.2;
//			
//			if (Math.abs( 0 - this["_image" + _change].x) < 1 ) {
//				removeEventListener(Event.ENTER_FRAME, _changeMotion);
//				this["_image" + _change].x = 0;
//				this["_image" + _current].x = (_dir == "next") ? ( -_viewWidth):_viewWidth;
//				_current = _change;
//				_isIng = false;
//				dispatchEvent(new Event(Event.COMPLETE));
//				trace("_isIng false");
//				
//			}
//		}
	}
}