package hansune.sets
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * CycleImageSlider 에 사용하는 아이템
	 * 다른 형태의 아이템이 필요하다면 상속을 받아 꾸며주기를..
	 * @author hanhyonsoo
	 * 
	 */
	public class SliderItem extends Sprite
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
		public var frontItem:SliderItem;
		/**
		 * 뒤에 있는 아이템
		 */
		public var rearItem:SliderItem;
		
		/**
		 * CycleImageSlider 에 사용하는 아이템 
		 * @param image 보여질 이미지
		 * @param id 분별 인덱스
		 * 
		 */
		public function SliderItem(image:Bitmap = null, id:String = "")
		{
			super();
			this.id = id;
			this.image = image;
			
			if(image != null) {
				addChild(image);
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
		public function clone():SliderItem {
			var img:Bitmap = new Bitmap(this.image.bitmapData.clone());
			var slider:SliderItem = new SliderItem(img, this.id);
			slider.viewRect = this.viewRect;
			slider.frontItem = this.frontItem;
			slider.rearItem = this.rearItem;
			slider.label = this.label;
			return slider;
		}
		
		
		/**
		 * 이미지 비트맵
		 */
		public function get image():Bitmap
		{
			return _image;
		}

		/**
		 * @private
		 */
		public function set image(value:Bitmap):void
		{
			if(value == null) return;
			_image = value;
			addChild(image);
			if(ms != null) {
				addChild(ms);
				image.mask = ms;
				image.x = -_viewRect.x;
				image.y = -_viewRect.y;
			}
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
					addChild(ms);
					image.mask = ms;
					image.x = -_viewRect.x;
					image.y = -_viewRect.y;
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