package hansune.events
{
	import flash.events.Event;
	
	public class PropertyEvent extends Event
	{
		public static const PROPERTY:String = "property";
		
		public var oldValue:Object;
		public var newValue:Object;
		public var kind:String;
		
		public function PropertyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, kind:String = null, newValue:Object = null, oldValue:Object = null)
		{
			super(type, bubbles, cancelable);
			this.oldValue = oldValue;
			this.newValue = newValue;
			this.kind = kind;
		}
		
		override public function clone():Event {
			return new PropertyEvent(type, bubbles, cancelable, kind, newValue, oldValue);
		}
	}
}