package hansune.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import hansune.Hansune;
	import hansune.events.XLibraryEvent;
	
	/**
	 * 에러 발생시 
	 */
	[Event(name="error", type="hansune.events.XLibraryEvent")]
	
	/**
	 * 검색된 단어 발견시 text = 제한되는 단어
	 */
	[Event(name="x", type="hansune.events.XLibraryEvent")]
	
	/**
	 * 검색된 단어가 없을 때 text = 검색한 단어
	 */
	[Event(name="notFind", type="hansune.events.XLibraryEvent")]
	
	/**
	 * 텍스트 로드 완료시
	 */
	[Event(name="loadOk", type="hansune.events.XLibraryEvent")]
	
	/**
	 * XLibrary 는 
	 * 문장에서 주어진 텍스트를 포함하는지 검색하는 기능을 수행합니다.
	 * */
	
	public class XLibrary extends EventDispatcher 
	{
		
		/**
		 * 제한 텍스트 모음
		 */
		public var source:Array;
		
		/**
		 * 텍스트 파일에서 단어를 구분하는 구분자.
		 */
		public var delimiter:String = "\r\n";
		
		/**
		 * 프레임당 검색하는 단어의 개수<br/ >
		 * 검색해야 할 단어의 수가 많을 경우 화면 갱신이 늦어질 수 있어서
		 * 1프레임당 계산해야 하는 단어수를 제한한다.
		 */
		public var searchCountByFrame:int = 300;
		
		/**
		 * XLibrary 생성자
		 */
		public function XLibrary(){Hansune.copyright();}
		
		/**
		 * 검색할 단어를 저장한 텍스트 파일을 저장한다.
		 * @param fileURL
		 * 
		 */
		public function loadXTextFile(fileURL:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			var request:URLRequest = new URLRequest(fileURL);
			
			try {
				loader.load(request);
			} catch (err:Error) {
				trace("unable to load ",fileURL);
			}
		}
		
		private function loadComplete(e:Event):void{
			source = [];
			var string:String = e.target.data;
			source = string.split(delimiter);
			trace(source.length, "words input");
			dispatchEvent(new XLibraryEvent(XLibraryEvent.LOAD_OK));
		}
		
		private function ioError(e:IOErrorEvent):void{
			dispatchEvent(new XLibraryEvent(XLibraryEvent.ERROR, e.text));
		}
		
		private var sr:Sprite = new Sprite();
		private var srTxt:String = "";
		private var isSearch:Boolean = false;
		private var count:int = 0;
		
		/**
		 * 주어진 문장에서 필터링이 필요한 단어가 있는지 검사한다.< br />
		 * 1프레임당 searchCountByFrame 수 만큼 검색하므로, 반드시 이벤트를 받아 결과값을 받아야 한다.< br />
		 * 검색 중에는 다른 검색을 제한한다.
		 * @param value 검색을 수행할 문장
		 * @return 필터링이 필요한 단어가 있다면 false, 반대의 경우는 true
		 * 
		 */
		public function search(value:String):void {
			
			if(source.length < 0) throw Error("source is not existing");
			if(isSearch) return;
			isSearch = true;
			srTxt = value;
			count = 0;
			sr.addEventListener(Event.ENTER_FRAME, onSearch);
			//trace(source.length);
		}
		
		public function stop():void {
			isSearch = false;
			sr.removeEventListener(Event.ENTER_FRAME, onSearch);
		}
		
		private function onSearch(e:Event):void {
			
			var pattern:RegExp;
			var result:int;
			var toFind:int = Math.min(source.length - count, searchCountByFrame);
			var len:int = count + toFind;
			if(toFind < 1) {
				stop();
				dispatchEvent(new XLibraryEvent(XLibraryEvent.NOT_FIND, srTxt));
				return;
			}
			var start:int = count;
			for(var i:int=start; i<len; ++i){
				count ++;
				if(source[i].length < 1) continue;
				pattern = new RegExp(source[i], "i");
				result = srTxt.search(pattern);
				
				if(result >= 0){
					trace("limited word - ", i, source[i]);//the complete matching substring
					dispatchEvent(new XLibraryEvent(XLibraryEvent.X, source[i]));
					stop();
					return;
				}
			}
			
			if(source.length - count <= 0) {
				stop();
				dispatchEvent(new XLibraryEvent(XLibraryEvent.NOT_FIND, srTxt));
				return;
			}
		}
	}
}

