package hansune.display
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
	import hansune.motion.easing.Linear;
	import hansune.motion.easing.Strong;
	import hansune.utils.Log;
	
	/**
	 * Sliding complete event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	public class ImageSlider extends Sprite
	{

		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			if(value <= 0) _duration = 1.3;
			else _duration = value;
		}

		public function get viewHeight():uint
		{
			return _viewHeight;
		}

		public function set viewHeight(value:uint):void
		{
			_viewHeight = value;
		}

		public function get viewWidth():uint
		{
			return _viewWidth;
		}

		public function set viewWidth(value:uint):void
		{
			_viewWidth = value;
		}

		public function get className():String {
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
		private var _viewWidth:uint;
		private var _viewHeight:uint;
		private var _mask:Shape;
		private var current:String;
		private var change:String;
		private var direction:int = JUST;
		
		private const container:Sprite = new Sprite();
		private const masking:Shape = new Shape();
		private var tweenShow:SooTween;
		private var tweenHide:SooTween;
		
		public var dissolve:Boolean = false;
		private var _easing:Function = Strong.easeInOut;
		private var _duration:Number = 1.3;
		public function set easing(ease:Function):void {
			if(ease == null) _easing = Linear.easeInOut;
			else _easing = ease;
		}
		
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
		
		protected function onIoError(e:IOErrorEvent):void{
			Log.e(className, e.toString());
			dispatchEvent(e.clone());
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
				beforePosition(imageB);
				
			} else {
				imageA.bitmapData = loadedBm.bitmapData.clone();
				change = "A";
				beforePosition(imageA);
			}
			
			loadedBm.bitmapData.dispose();
			
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
			var at:Number = (dissolve)? 0:1;
			tweenHide = SooTween.to(this["image" + current], duration, {x:tx, y:ty, alpha:at, ease:_easing, onComplete:endMotion});
			
			container.addChild(this["image" + change]);
			this["image" + change].alpha = (dissolve)? 0:1;
			if(tweenShow != null && tweenShow.isPlaying) tweenShow.finish();
			tweenShow = SooTween.to(this["image" + change], duration * 0.7, {x:0, y:0, alpha:1, ease:_easing});
		}
		
		private function endMotion():void {
			current = change;
			isIng = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}