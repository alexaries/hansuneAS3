package hansune.ui.button
{
	import flash.display.Sprite;
	
	public class AbstractButton extends Sprite
	{
		public var tweening:Boolean = false;
		/**
		 * 기본위치
		 * @default 
		 */
		protected var _lang:uint = 1;//english
		public function set language(value:uint):void {
			if(_lang == value) return;
			_lang = value;
			if(value == 1){
				toEnglish();
			} else {
				toChinese();
			}
		}
		
		public function get language():uint {
			return _lang;
		}
		
		public function AbstractButton()
		{
			super();
		}
		
		protected function toEnglish():void {}
		protected function toChinese():void {}
		
		protected var _eventEnable:Boolean = true;
		public function set eventEnable(value:Boolean):void {}
		public function get eventEnable():Boolean {return _eventEnable;}
		public function reset():void {}
	}
}