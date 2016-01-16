package hansune.loader {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * <p>텍스트 파일에 외부변수 값을 저장해서 쉽게 사용할 수 있게 한다.</p>
	 * <p> 텍스트 파일 예시 -
	 * test=true
	 * //초기화 타임
	 * resetTime=40
	 * //마우스 포인트
	 * mouse=true
	 * //게임시간(프레임수)
	 * checkTotal=300
	 * 
	 * </p>
	 * @author hyonsoohan
	 * 
	 */
	dynamic public class SettingLoader extends Proxy implements IEventDispatcher {

		static private var _instance:SettingLoader;
		private var _eventDispatcher:EventDispatcher;
		private var _data:Array;
		private var _isLoaded:Boolean;
		private var _urlLoader:URLLoader;

		public function get isLoaded():Boolean {
			return _isLoaded;
		}

		public function SettingLoader(enforcer:SingletonEnforcer){
			_eventDispatcher = new EventDispatcher();
			_isLoaded = false;

		}
		
		
		/**
		 * 배열값, 콤마로 구분된 값일 경우 배열생성
		 * @param name
		 * @param defaultValue 기본값
		 * @return 
		 * 
		 */
		static public function getArray(name:String, defaultValue:Array):Array {
			if(_instance == null) return defaultValue;
			var p:* = getInstance()[name];
			if(p == null) return defaultValue;
			
			var arr:Array = String(p).split(",");
			var nArr:Array = [];
			for each (var item:String in arr) 
			{
				var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
				
				if(item == "true" || item == "false") {
					nArr.push(Boolean(item));
				}
				else if(!regx.test(item)) {
					nArr.push(item);
				}
				else {
					nArr.push(Number(item));
				}
			}
			
			return nArr;
		}
		
		
		/**
		 * 스트링값
		 * @param name 속성
		 * @param defaultValue 기본값, 해당 값이 없을 경우
		 * @return 
		 * 
		 */
		static public function getString(name:String, defaultValue:String):String {
			if(_instance == null) return defaultValue;
			var p:* = getInstance()[name];
			if(p == null) return defaultValue;
			return String(p);
		}
		
		/**
		 * 참 거짓 값
		 * @param name 속성
		 * @param defaultValue 기본값, 해당 값이 없을 경우
		 * @return true, false 문자는 그대로 boolean  적용됨.
		 * 
		 */
		static public function getBoolean(name:String, defaultValue:Boolean):Boolean {
			if(_instance == null) return defaultValue;
			var p:* = getInstance()[name];
			
			if(p == null) return defaultValue;
			if(p == "true") {
				return true;
			}
			else if(p == "false"){
				return false;
			}
			return Boolean(p);
		}
		
		/**
		 * 정수 
		 * @param name 속성명
		 * @param defaultValue 기본값, 해당 값이 없거나 숫자형이 아닌 경우
		 * @return 
		 * 
		 */
		static public function getInt(name:String, defaultValue:int):int {
			if(_instance == null) return defaultValue;
			var p:* = getInstance()[name];
			if(p == null) return defaultValue;
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(!regx.test(String(p))) {
				return defaultValue;
			}
			return int(p);
		}
		
		/**
		 * 숫자 
		 * @param name 속성명
		 * @param defaultValue 기본값, 해당 값이 없거나 숫자형이 아닌 경우
		 * @return 
		 * 
		 */
		static public function getNumber(name:String, defaultValue:Number):Number {
			if(_instance == null) return defaultValue;
			var p:* = getInstance()[name];
			if(p == null) return defaultValue;
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(!regx.test(String(p))) {
				return defaultValue;
			}
			return Number(p);
		}

		private function onFileLoaded(event:Event):void {

			_data = new Array();

			var loadTxt:String = event.target.data;
			var expression:RegExp=/[\n\r\f]/g;
			var strArray:Array = loadTxt.split(expression);
			var len:int = strArray.length;

			for(var i:int = 0; i < len; ++i){

				if(strArray[i].charAt(0) != " " && strArray[i].charAt(0) != "/"){

					var varArray:Array = String(strArray[i]).split("=");

					_data.push({name:varArray[0], value:varArray[1]});

				}
			}

			_isLoaded = true;
			_urlLoader.removeEventListener(Event.COMPLETE, onFileLoaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public static function getInstance():SettingLoader {

			if(SettingLoader._instance == null){
				SettingLoader._instance = new SettingLoader(new SingletonEnforcer());
			}
			return SettingLoader._instance;
		}

		flash_proxy override function getProperty(name:*):* {
			
			var chk:Boolean = false;
			for(var i:int=0;i<_data.length;++i){
				if (name == _data[i].name) {
					chk = true;
					break;
				}
			}
			if(chk){
				//trace("hss setting:", name, _data[i].value);
				return _data[i].value;
			} else {
				//trace("hss setting:", name, "null");
				return null;
			}
		}
		
		flash_proxy override function callProperty(name:*, ...parameters):* {
			return null;
		}

		public function load(url:String):void{
			var urlRequest:URLRequest = new URLRequest(url);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onFileLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, err);
			_urlLoader.load(urlRequest);
		}
		
		private function err(e:IOErrorEvent):void
		{
			trace("can't find the setting file");
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, err);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "can't find the setting file"));
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int=0, weakRef:Boolean=false):void{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
		}

		public function dispatchEvent(event:Event):Boolean{
			return _eventDispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean{
			return _eventDispatcher.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean{
			return _eventDispatcher.willTrigger(type);
		}
	}
}

class SingletonEnforcer{}

