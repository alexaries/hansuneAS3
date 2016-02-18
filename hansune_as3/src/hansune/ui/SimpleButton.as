package hansune.ui
{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import hansune.events.ButtonEvent;
	
	[Event(name="click", type="hansune.events.ButtonEvent")]
	
	public class SimpleButton extends Sprite
	{
		
		private var _eventEnable:Boolean = true;
		private var _upDef:Bitmap;
		
		/**
		 * default image for up state 
		 * @param bm
		 * 
		 */
		public function set upImage(bm:Bitmap):void {
			_upDef = bm;
			addChild(_upDef);
		}
		
		/**
		 * default image 
		 * @return bitmap
		 * 
		 */
		public function get upImage():Bitmap {
			return _upDef;
		}
		
		private var _dnDef:Bitmap;
		
		
		/**
		 * down image 
		 * @return bitmap
		 * 
		 */
		public function get downImage():Bitmap {
			return _dnDef;
		}
		
		/**
		 * default image for down image 
		 * @param bm
		 * 
		 */
		public function set downImage(bm:Bitmap):void {
			_dnDef = bm;
			addChild(_dnDef);
		}
		
		/**
		 * Whether it changes up/down state by clicking or not.
		 */
		public var stateChagiable:Boolean = true;
		
		public function set selected(value:Boolean):void {
			if(value){
				setDownState();
			} else {
				setUpState();
			}
		}
		
		public function get selected():Boolean {
			return (_dnDef.visible);
		}
		
		public var id:int = -1;
		
		public function SimpleButton(upImage:Bitmap = null, downImage:Bitmap = null)
		{
			super();
			trans = new Sprite();
			trans.graphics.beginFill(0);
			trans.graphics.drawRect(0,0,1,1);
			trans.graphics.endFill();
			trans.alpha = 0;
			
			this.upImage = upImage;
			this.downImage = downImage;
			
			eventEnable = _eventEnable;
			selected = false;
		}
		
		/**
		 * 하단이미지 위치 조정, 상하이미지를 맞추기 위함.
		 * @default 
		 */
		protected var offset:Point = new Point();
		public function setOffset(xx:Number, yy:Number):void {
			_dnDef.x = offset.x = xx;
			_dnDef.y = offset.y = yy;
		}
		
		protected var trans:Sprite;
		/**
		 * 마우스 이벤트 발생 여부 
		 * @param value
		 * 
		 */		
		public function set eventEnable(value:Boolean):void {
			if(value){
				addChild(trans);
				trans.addEventListener(MouseEvent.CLICK, onClick);
				trans.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			} else {
				if(contains(trans)) removeChild(trans);
				trans.removeEventListener(MouseEvent.CLICK, onClick);
				trans.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			}
		}
		
		public function get eventEnable():Boolean {
			return _eventEnable;
		}
		
		/**
		 * 지정한 마우스 영역을 마우스 이벤트로 사용할 것인지
		 * 기본 false 
		 * true 이면 이미지 크기에 따라 변하지 않음
		 */
		public var useMouseArea:Boolean = false;
		
		/**
		 * 마우스 영역 지정 
		 * @param xx
		 * @param yy
		 * @param ww
		 * @param hh
		 * 
		 */
		public function setMouseArea(xx:Number, yy:Number, ww:Number, hh:Number):void {
			trans.x = xx;
			trans.y = yy;
			trans.width = ww;
			trans.height = hh;
		}
		
		private var downCheck:Boolean = false;
		private function onClick(e:MouseEvent):void {
			
			if(eventEnable) dispatchEvent(new ButtonEvent(ButtonEvent.CLICK, false, false, "", id));
			if(!stateChagiable) return;
			if(downCheck) {
				//trace("downCheck == true");
				//setUpState();
				setTimeout(setUpState, 150);
			}
			else {
				//trace("downCheck == false");
				setDownState();
				setTimeout(setUpState, 150);
			}
		}
		
		private function onDown(e:MouseEvent):void {
			if(!stateChagiable) return;
			setDownState();
		}
		
		protected function setDownState():void {
			downCheck = true;
			_upDef.alpha = 1.0;
			_upDef.visible = false;
			_dnDef.alpha = 1.0;
			_dnDef.visible = true;
			
			if(!useMouseArea){
				trans.width = _dnDef.width;
				trans.height = _dnDef.height;
				trans.x = _dnDef.x;
				trans.y = _dnDef.y;
			}
		}
		
		protected function setUpState():void {
			downCheck = false;
			_upDef.alpha = 1.0;
			_upDef.visible = true;
			_dnDef.alpha = 1.0;
			_dnDef.visible = false;
			
			if(!useMouseArea){
				trans.width = _upDef.width;
				trans.height = _upDef.height;
				trans.x = _upDef.x;
				trans.y = _upDef.y;
			}
		}
	}
}