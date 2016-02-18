package hansune.events
{
	import flash.events.Event;
	
	public class ButtonEvent extends Event
	{
		static public const INIT:String = "btInit";
		static public const END:String = "btEnd";
		static public const RESET:String = "btReset";
		static public const CLICK:String = "btClick";
		static public const RELEASE:String = "btRelease";
		static public const DRAG:String = "btDrag";
		static public const ERROR:String = "btError";
		
		private var _intValue:uint;
		public function get intiger():uint{
			return _intValue;
		}
		
		private var _stringValue:String;
		public function get data():String {
			return _stringValue;
		}
		
		override public function toString():String{
			return this.type + "/" + this.bubbles + "/" + this.cancelable + "/" + this._stringValue + "/" + this._intValue;
		} 
		
		override public function clone():Event {
			const e:ButtonEvent = new ButtonEvent(type, bubbles, cancelable, _stringValue, _intValue);
			return e;
		}
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, stringValue:String = "", intValue:uint=0)
		{
			_intValue = intValue;
			_stringValue = stringValue;
			super(type, bubbles, cancelable); 
		}
		
	}
}