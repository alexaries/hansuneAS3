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
		
		private var _value:uint;
		public function get intiger():uint{
			return _value;
		}
		
		private var _data:String;
		public function get data():String {
			return _data;
		}
		
		override public function toString():String{
			return this.type + "/" + this.bubbles + "/" + this.cancelable + "/" + this._data + "/" + this._value;
		} 
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, stringValue:String = "", intigerValue:uint=0)
		{
			_value = intigerValue;
			_data = stringValue;
			super(type, bubbles, cancelable);
		}
	}
}