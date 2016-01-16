package hansune.events
{
	import flash.events.Event;
	
	/**
	 * XLibrary 관련 이벤트
	 * @author hyonsoohan
	 * 
	 */
	public class XLibraryEvent extends Event
	{
		/**
		 * 파일 로드 완료
		 */
		public static const LOAD_OK:String = "loadOk";
		
		/**
		 * 검색된 단어가 있을 경우
		 */
		public static const X:String = "x";
		
		/**
		 * 에러
		 */
		public static const ERROR:String = "error";
		
		/**
		 * 검색된 것이 없음
		 */
		public static const NOT_FIND:String = "notFind";
		
		/**
		 * 검색된 단어
		 */
		public var text:String = "";
		
		public function XLibraryEvent(type:String, text:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.text = text;
		}
		
		override public function clone():Event {
			return new XLibraryEvent(type, text, bubbles, cancelable);
		}
	}
}