package hansune.ui
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import hansune.motion.SooTween;
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * CycleImageSlider 에 사용하는 아이템
	 * @author hanhyonsoo
	 * 
	 */
	public class ImageThumbSliderItem extends Sprite
	{
		
		/**
		 * 아이템 아이디
		 */
		public var id:String;
		
		/**
		 * target x 
		 */
		internal var tx:Number = 0;
		/**
		 * target y 
		 */
		internal var ty:Number = 0;
		
		/**
		 * 이미지
		 */
		protected var _image:Bitmap;
		/**
		 * 보여지는 영역
		 */
		protected var _viewRect:Rectangle;
		/**
		 * 라벨용 -> 추가작업용.
		 */
		protected var _tf:TextField;
		
		override public function get height():Number {
			if(_viewRect == null) {
				return super.height;
			}
			else {
				return _viewRect.height;
			}
		}
		
		override public function get width():Number {
			if(_viewRect == null) {
				return super.width;
			}
			else {
				return _viewRect.width;
			}
		}
		
		//mask shape
		protected var ms:Shape;
		
		/**
		 * 앞에 있는 아이템
		 */
		public var frontItem:ImageThumbSliderItem;
		/**
		 * 뒤에 있는 아이템
		 */
		public var rearItem:ImageThumbSliderItem;
		
		
		public var path:String;
		
		
		/**
		 * CycleImageSlider 에 사용하는 아이템 
		 * @param path 이미지 경
		 * @param id 분별 인덱스
		 * 
		 */
		public function ImageThumbSliderItem(path:String = null, id:String = "")
		{
			super();
			this.id = id;
			this.path = path;
		}
		
		private function cleanUp():void {
			release();
			if(_viewRect != null) {
				graphics.beginFill(0xaaaaaa);
				graphics.drawRect(0, 0, _viewRect.width, _viewRect.height);
				graphics.endFill();
			}
		}
		
		public function load():void {
			
			cleanUp();
			
			if(path == null || path.length < 1) return;
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompLoad);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			ld.load(new URLRequest(path));
		}
		
		protected function onIoError(event:IOErrorEvent):void {
			trace(event.text);
			dispatchEvent(event.clone());
		}
		
		private var initialMotion:Boolean = false;
		protected function onCompLoad(event:Event):void {
			trace(event.type);
			this.setImage(event.currentTarget.content as Bitmap);
			if(this.image != null) {
				dispatchEvent(event.clone());
			}
		}
		
		/**
		 * 텍스트를 적음.  디버깅용?
		 * @param t
		 * 
		 */
		public function set label(t:String):void {
			if(_tf == null) _tf = new TextField();
			_tf.text = t;
			_tf.mouseEnabled = false;
			addChild(_tf);
		}
		
		/**
		 * 텍스트를 적음.  디버깅용?
		 * @return 
		 * 
		 */
		public function get label():String {
			if(_tf != null) return _tf.text;
			return "";
		}
		
		/**
		 *  
		 * @return 
		 * 
		 */
		public function clone():ImageThumbSliderItem {
			var slider:ImageThumbSliderItem = new ImageThumbSliderItem(this.path, this.id);
			slider.setImage(new Bitmap(this.image.bitmapData.clone()));
			slider.viewRect = this.viewRect;
			slider.frontItem = this.frontItem;
			slider.rearItem = this.rearItem;
			slider.label = this.label;
			return slider;
		}
		
		private var _scaling:int = ImageThumbSliderItemScaling.FILL_RECT;
		
		public function get scaling():int {
			return _scaling;
		}
		
		public function set scaling(value:int):void {
			_scaling = value;
			updateScale();
		}
		// TODO
		private function updateScale():void {
			if(ms != null && image != null) {
				addChild(ms);
				image.mask = ms;
				var scale:Number = 1.0;
				switch(_scaling) {
					case ImageThumbSliderItemScaling.NO_SCALE:
						image.x = -_viewRect.x;
						image.y = -_viewRect.y;
						image.scaleX = 1;
						image.scaleY = 1;
						break;
					
					case ImageThumbSliderItemScaling.FULL_IMAGE:
						if(image.width > _viewRect.width || image.height > _viewRect.height) {
							scale = Math.min(_viewRect.width / image.width, _viewRect.height / image.height);
						}
						image.scaleX = scale;
						image.scaleY = scale;
						image.x = Math.floor((_viewRect.width - image.width) / 2);
						image.y = Math.floor((_viewRect.height - image.height) / 2);
						break;
					
					case ImageThumbSliderItemScaling.FILL_RECT:
						if(image.width > _viewRect.width || image.height > _viewRect.height) {
							scale = Math.max(_viewRect.width / image.width, _viewRect.height / image.height);
						}
						image.scaleX = scale;
						image.scaleY = scale;
						image.x = Math.floor((_viewRect.width - image.width) / 2);
						image.y = Math.floor((_viewRect.height - image.height) / 2);
						break;
				}
			}
		}
		
		
		/**
		 * 이미지 비트맵
		 */
		public function get image():Bitmap
		{
			return _image;
		}
		
		private function setImage(value:Bitmap):void
		{
			if(value == null) return;
			_image = value;
			addChild(image);
			updateScale();
			
			image.alpha = 0;
			SooTween.alphaTo(image, 1, 0.3);
		}

		/**
		 * 이미지의 보여지는 영역을 제한함, 마스크 시킴.
		 * @param rect 보여지는 영역
		 * 
		 */
		public function set viewRect(rect:Rectangle):void {
			if(rect != null) {
				_viewRect = rect;
				if(ms == null) ms = new Shape();
				ms.graphics.clear();
				ms.graphics.beginFill(0);
				ms.graphics.drawRect(0, 0, _viewRect.width, _viewRect.height);
				ms.graphics.endFill();
				
				if(image != null) {
					updateScale();
				}
			}
			else {
				_viewRect = null;
				if(ms != null) {
					ms.graphics.clear();
					if(contains(ms)) removeChild(ms);
				}
				
				if(image != null){
					image.mask = null;
					image.x = 0;
					image.y = 0;
				}
			}
		}
		
		/**
		 * 이미지의 보여지는 영역, 마스크 시킴.
		 * @return 
		 * 
		 */
		public function get viewRect():Rectangle {
			if(ms == null) {
				return null;
			}
			else {
				return _viewRect;
			}
		}
		
		/**
		 * Release containing items.
		 * 포함하고 있는 요소들의 연결을 해제 시킨다.
		 */
		public function release():void {
			if(contains(ms)) removeChild(ms);
			if(contains(image)) removeChild(image);
			image.bitmapData.dispose();
		}
		
	}
}