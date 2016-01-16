package hansune.ui.button
{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import hansune.events.ButtonEvent;
	import hansune.motion.SooTween;

	[Event(name="click", type="hansune.events.ButtonEvent")]
	public class AbsPushButton extends AbstractButton
	{
		private var _upEng:Bitmap;
		public function set upEngSprite(bm:Bitmap):void {
			_upEng = bm;
			
			addChild(_upEng);
		}
		
		private var _dnEng:Bitmap;
		public function set downEngSprite(bm:Bitmap):void {
			_dnEng = bm;
			addChild(_dnEng);
		}
		
		private var _upChn:Bitmap;
		public function set upChnSprite(bm:Bitmap):void {
			_upChn = bm;
			
			addChild(_upChn);
		}
		
		private var _dnChn:Bitmap;
		public function set downChnSprite(bm:Bitmap):void {
			_dnChn = bm;
			addChild(_dnChn);
			
		}
		
		/**
		 * 상태변화를 할 것인지
		 */
		public var selectTogglable:Boolean = true;
		private var _selected:Boolean = false;
		public function set selected(value:Boolean):void {
			
			if(value){
				setDownState();
				
			} else {
				setUpState();
			}
			
		}
		
		public function get selected():Boolean {
			return (_dnEng.visible || _dnChn.visible);
		}
		
		public function AbsPushButton()
		{
			super();
			trans = new Sprite();
			trans.graphics.beginFill(0);
			trans.graphics.drawRect(0,0,1,1);
			trans.graphics.endFill();
			trans.alpha = 0;
		}
		
		/**
		 * 하단이미지 위치 조정, 상하이미지를 맞추기 위함.
		 * @default 
		 */
		protected var offset:Point = new Point();
		public function setOffset(xx:Number, yy:Number):void {
			_dnEng.x = offset.x = xx;
			_dnEng.y = offset.y = yy;
			_dnChn.x = xx;
			_dnChn.y = yy;
		}
		
		protected var trans:Sprite;
		override public function set eventEnable(value:Boolean):void {
			if(value){
				addChild(trans);
				trans.addEventListener(MouseEvent.CLICK, onClick);
				trans.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			} else {
				if(contains(trans)) addChild(trans);
				trans.removeEventListener(MouseEvent.CLICK, onClick);
				trans.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			}
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
		/**
		 *이벤트 활성화여부 
		 */
		
		private function onClick(e:MouseEvent):void {
			
			if(eventEnable) dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
			if(!selectTogglable) return;
			setUpState();
		}
		
		private function onDown(e:MouseEvent):void {
			if(!selectTogglable) return;
			setDownState();
		}
		
		private function setDownState():void {
			if(_lang){
				_upChn.alpha = 1.0;
				_upChn.visible = false;
				_dnChn.alpha = 1.0;
				_dnChn.visible = false;
				_upEng.alpha = 1.0;
				_upEng.visible = false;
				_dnEng.alpha = 1.0;
				_dnEng.visible = true;
			} else {
				_upChn.alpha = 1.0;
				_upChn.visible = false;
				_dnChn.alpha = 1.0;
				_dnChn.visible = true;
				_upEng.alpha = 1.0;
				_upEng.visible = false;
				_dnEng.alpha = 1.0;
				_dnEng.visible = false;
			}
			if(!useMouseArea){
				trans.width = _dnEng.width;
				trans.height = _dnEng.height;
				trans.x = _dnEng.x;
				trans.y = _dnEng.y;
			}
		}
		
		private function setUpState():void {
			if(_lang){
				_upChn.alpha = 1.0;
				_upChn.visible = false;
				_dnChn.alpha = 1.0;
				_dnChn.visible = false;
				_upEng.alpha = 1.0;
				_upEng.visible = true;
				_dnEng.alpha = 1.0;
				_dnEng.visible = false;
			} else {
				_upChn.alpha = 1.0;
				_upChn.visible = true;
				_dnChn.alpha = 1.0;
				_dnChn.visible = false;
				_upEng.alpha = 1.0;
				_upEng.visible = false;
				_dnEng.alpha = 1.0;
				_dnEng.visible = false;
			}
			if(!useMouseArea){
				trans.width = _upEng.width;
				trans.height = _upEng.height;
				trans.x = _upEng.x;
				trans.y = _upEng.y;
			}
		}
		
		override protected function toChinese() : void {
			if(!stage) {
				_upChn.alpha = 1.0;
				_upChn.visible = true;
				_upEng.alpha = 1.0;
				_upEng.visible = false;
				return;
			}
			if(tweening) return;
			tweening = true;
			//tween = new TweenMax(_upEng, 0.3, {y:20, alpha:0.0});
			SooTween.alphaTo(_upEng, 0, 0.3);
			SooTween.moveTo(_upEng, _upEng.x, 20, 0.3);
			//_upChn.y = -20;
			_upChn.alpha = 0.0;
			_upChn.visible = true;
			//tween = new TweenMax(_upChn, 0.5, {y:0, alpha:1.0,  onComplete:chnEndTween});
			SooTween.alphaTo(_upChn, 0, 0.3);
			SooTween.moveTo(_upChn, _upChn.x, 0, 0.3, null, chnEndTween);
		}
		private function chnEndTween():void {
			_upEng.visible = false;
			_upEng.y = 0;
			_upEng.alpha = 1.0;
			_dnEng.visible = false;
			tweening = false;
		}
		
		override protected function toEnglish() : void {
			if(!stage) {
				_upChn.alpha = 1.0;
				_upChn.visible = false;
				_upEng.alpha = 1.0;
				_upEng.visible = true;
				return;
			}
			if(tweening) return;
			tweening = true;
			//tween = new TweenMax(_upChn, 0.3, {y:20, alpha:0.0});
			SooTween.alphaTo(_upChn, 0, 0.3);
			SooTween.moveTo(_upEng, _upChn.x, 20, 0.3);
			//_upEng.y = -20;
			_upEng.alpha = 0.0;
			_upEng.visible = true;
			//tween = new TweenMax(_upEng, 0.5, {y:0, alpha:1.0,  onComplete:engEndTween});
			SooTween.alphaTo(_upEng, 0, 0.3);
			SooTween.moveTo(_upChn, _upEng.x, 0, 0.3, null, chnEndTween);
		}
		
		private function engEndTween():void {
			_upChn.visible = false;
			_upChn.y = 0;
			_upChn.alpha = 1.0;
			_dnChn.visible = false;
			tweening = false;
		}
	}
}