package fla
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import hansune.ui.keyMeta.FuncKey;
	import hansune.ui.keyMeta.KeyInfo;
	import hansune.ui.keyMeta.KeyType;
	
	[CityEvent(name = "select", type = "flash.events.Event")]
	/**
	 * 키버튼 아이템을 인터랙션주는 부분
	 * @author hanhyonsoo
	 */
	public class KeyButton extends EventDispatcher
	{
		static public const ENGLISH:int = 0;
		static public const KOREAN:int = 1;
		static public const SPECIAL:int = 2;
		
		/**
		 * values
		 */
		public var keyInfo:KeyInfo;
		private var _btn:KeyButtonItem;
		
		public  function get select():Boolean {
			return _btn.select;
		}
		
		public function set select(value:Boolean):void {
			_btn.select = value;
		}
		
		private var _current:int = ENGLISH;
		public function get current():int {
			return _btn.current;
		}
		public function set current(value:int):void {
			_btn.current = value;
		}
		
		private var _shift:Boolean = false;
		public function set shift(value:Boolean):void {
			_btn.shift = value;
			_shift = value;
		}
		public function get shift():Boolean {
			return _shift;
		}
		
		public function KeyButton(linkTo:KeyButtonItem, _keyInfo:KeyInfo) 
		{
			keyInfo = _keyInfo;
			
			if (keyInfo.lowerValue == FuncKey.CAPS) {
				_isCaps = true;
			} 
			if (keyInfo.lowerValue == FuncKey.SHIFT) {
				_isShift = true;
			}
			
			_btn = linkTo;
			_btn.shift = false;
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, _onUp);
			_btn.addEventListener(MouseEvent.ROLL_OUT, _onOut);
			_btn.addEventListener(MouseEvent.MOUSE_UP, _onOut);
		}
		
		private var _isCaps:Boolean = false;
		private var _isShift:Boolean = false;
		private function _onDown(e:MouseEvent):void {
			if(!_isCaps && !_isShift){
				_btn.select = true;
			}
		}
		
		private function _onUp(e:MouseEvent):void {
			if(_isCaps || _isShift){
				_btn.select = (_btn.select)? false : true;
			} else {
				_btn.select = true;
			}
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function _onOut(e:MouseEvent):void {
			if(!_isCaps && !_isShift){
				_btn.select = false;
			}
		}
	}
}