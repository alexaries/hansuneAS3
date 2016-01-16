package fla
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import hansune.events.HangleTextEvent;
	import hansune.text.HangleUnicodeComposer;
	import hansune.ui.keyMeta.*;
	
	/**
	 * ...
	 * @author hansoo
	 */
	public class iKeyboard extends Sprite
	{
		private var composer:HangleUnicodeComposer;
		private var keys:Vector.<KeyButton>;
		private const KEY_LENGTH:int = 31;
		
		public function iKeyboard() 
		{
			composer = new HangleUnicodeComposer();
			composer.addEventListener(HangleTextEvent.UPDATE, onUpdate);
			composer.restrict = 50;//글자수 제한
			
			keys = new Vector.<KeyButton>(KEY_LENGTH, true);
			var i:int;
			var keyinfo:KeyInfoData = new KeyInfoData();
			var keyItem:fla.KeyButtonItem;
			for (i = 0; i < KEY_LENGTH; i++) 
			{
				keyItem = new KeyButtonItem(this["key" + i]);
				if(i== 26 || i == 27 || i == 29) keyItem.isHoldKey = true;
				keys[i] = new KeyButton(keyItem, keyinfo.getInfo(i));
			}
			
			init();
		}
		
		
		public var compString:String = "";
		public var extraString:String = "";
		private var eee:Event = new Event(Event.CHANGE);
		private function onUpdate(e:HangleTextEvent):void {
			
			compString = composer.compositionString;
			extraString = composer.extra;
			dispatchEvent(eee);
		}
		
		public function init():void {
			var i:int;
			for (i = 0; i < KEY_LENGTH; i++) 
			{
				keys[i].current = KeyButton.ENGLISH;
				keys[i].addEventListener(Event.SELECT, onSelect);
			}
		}
		
		public function end():void {
			var i:int;
			for (i = 0; i < KEY_LENGTH; i++) 
			{
				keys[i].current = KeyButton.ENGLISH;
				keys[i].removeEventListener(Event.SELECT, onSelect);
			}
		}
		
		private var isShift:Boolean = false;
		private var current:int = KeyButton.ENGLISH;
		private function onSelect(e:Event):void {
			
			var i:int;
			var key:KeyButton = e.target as KeyButton;
			
			if (key.keyInfo.type == KeyType.NORMAL_KEY) {
				
				if (!isShift) {
					switch(current) {
						case KeyButton.KOREAN :
							composer.addJamo(key.keyInfo.lowerValue);
							break;
						case KeyButton.ENGLISH :
							composer.addSpacialChar(key.keyInfo.upperValue);
							break;
						case KeyButton.SPECIAL :
							composer.addSpacialChar(key.keyInfo.extraValue);
							break;
					}
				} else {
					switch(current) {
						case KeyButton.KOREAN :
							composer.addJamo(doubling(key.keyInfo.lowerValue));
							break;
						case KeyButton.ENGLISH :
							composer.addSpacialChar(String(key.keyInfo.upperValue).toUpperCase());
							break;
						case KeyButton.SPECIAL :
							composer.addSpacialChar(key.keyInfo.extraValue);
							break;
					}
				}
				
				
			} else {
				
				switch(key.keyInfo.lowerValue) {
					
					case FuncKey.SPACE :
						composer.addSpacialChar(" ");
						break;
						
					case FuncKey.ENTER :
						trace("enter");
						break;
						
					case FuncKey.BACK_SPACE :
						composer.backSpace();
						break;
					
					case FuncKey.SPECIAL :
						for (i = 0; i < KEY_LENGTH; i++) {
							keys[i].current = KeyButton.SPECIAL;
						}
						current = KeyButton.SPECIAL;
						break;
						
					case FuncKey.KOR_ENG :
						if (current == KeyButton.ENGLISH) {
							for (i = 0; i < KEY_LENGTH; i++) {
								keys[i].current = KeyButton.KOREAN;
							}
							current = KeyButton.KOREAN;
						} else {
							for (i = 0; i < KEY_LENGTH; i++) {
								keys[i].current = KeyButton.ENGLISH
							}
							current = KeyButton.ENGLISH;
						}
						break;
						
					case FuncKey.SHIFT :
						if (key.keyInfo.lowerValue == FuncKey.SHIFT) {
							if (isShift) {
								for (i = 0; i < KEY_LENGTH; i++) {
									keys[i].shift = false;
								}
								isShift = false;
							} else {
								for (i = 0; i < KEY_LENGTH; i++) {
									keys[i].shift = true;
								}
								isShift = true;
							}
						}
						break;
					
					default :
						break;
				}
				
				
			}
		}
		
		
		private function doubling(s:String):String {
			switch(s) {
				case "ㅂ" :
					s = "ㅃ";
					break;
				case "ㅈ" :
					s = "ㅉ";
					break;
				
				case "ㄷ" :
					s = "ㄸ";
					break;
				case "ㄱ" :
					s = "ㄲ";
					break;
				case "ㅅ" :
					s = "ㅆ";
					break;
				case "ㅐ" :
					s = "ㅒ";
					break;
				case "ㅔ" :
					s = "ㅖ";
					break;
				default :
					break;
			}
			return s;
		}
		
	}

}