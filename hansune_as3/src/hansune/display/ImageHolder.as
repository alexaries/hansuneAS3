package hansune.display
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
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Load and Hold image
	 * @author hanhyonsoo
	 * 
	 */
	public class ImageHolder extends Sprite
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
		protected var masking:Shape;
		
		/**
		 * front item for chaining
		 */
		public var frontItem:ImageHolder;
		/**
		 * rear item for chaining
		 */
		public var rearItem:ImageHolder;
		
		
		public var path:String;
		
		
		/**
		 * ImageHolder constructor 
		 * @param path url to load image
		 * @param id just identity
		 * 
		 */
		public function ImageHolder(path:String = null, id:String = "")
		{
			super();
			this.id = id;
			this.path = path;
		}
		
		
		private var _backgroundColor:uint = 0xffffff;
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			if(_viewRect != null) {
				graphics.beginFill(value);
				graphics.drawRect(0, 0, _viewRect.width, _viewRect.height);
				graphics.endFill();
			}
		}
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		
		public function load(path:String = null):void {
			
			release();
			
			if(path != null) this.path = path; //use parameter
			
			if(this.path == null || this.path.length < 1) return;
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompLoad);
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			ld.load(new URLRequest(this.path));
			
		}
		
		protected function onIoError(event:IOErrorEvent):void {
			//trace(event.text);
			dispatchEvent(event.clone());
		}
		
		private var initialMotion:Boolean = false;
		protected function onCompLoad(event:Event):void {
			//trace(event.type);
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
		public function clone():ImageHolder {
			var slider:ImageHolder = new ImageHolder(this.path, this.id);
			slider.setImage(new Bitmap(this.image.bitmapData.clone()));
			slider.viewRect = this.viewRect;
			slider.frontItem = this.frontItem;
			slider.rearItem = this.rearItem;
			slider.label = this.label;
			return slider;
		}
		
		private var _scaling:int = ImageHolderScaling.FILL_RECT;
		
		public function get scaling():int {
			return _scaling;
		}
		
		public function set scaling(value:int):void {
			_scaling = value;
			updateScale();
		}
		// TODO
		private function updateScale():void {
			if(masking != null && image != null) {
				addChild(masking);
				image.mask = masking;
				var scale:Number = 1.0;
				switch(_scaling) {
					case ImageHolderScaling.NO_SCALE:
						image.x = -_viewRect.x;
						image.y = -_viewRect.y;
						image.scaleX = 1;
						image.scaleY = 1;
						break;
					
					case ImageHolderScaling.FULL_IMAGE:
						if(image.width > _viewRect.width || image.height > _viewRect.height) {
							scale = Math.min(_viewRect.width / image.width, _viewRect.height / image.height);
						}
						image.scaleX = scale;
						image.scaleY = scale;
						image.x = Math.floor((_viewRect.width - image.width) / 2);
						image.y = Math.floor((_viewRect.height - image.height) / 2);
						break;
					
					case ImageHolderScaling.FILL_RECT:
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
				if(masking == null) masking = new Shape();
				masking.graphics.clear();
				masking.graphics.beginFill(0);
				masking.graphics.drawRect(0, 0, _viewRect.width, _viewRect.height);
				masking.graphics.endFill();
				
				if(image != null) {
					updateScale();
				}
			}
			else {
				_viewRect = null;
				if(masking != null) {
					masking.graphics.clear();
					if(contains(masking)) removeChild(masking);
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
			if(masking == null) {
				return null;
			}
			else {
				return _viewRect;
			}
		}
		
		/**
		 * Release containing items.
		 */
		public function release():void {
			if(masking != null && contains(masking)) removeChild(masking);
			if(image != null && contains(image)) {
				removeChild(image);
				image.bitmapData.dispose();
			}
		}
		
	}
}