package hansune.events
{
	import flash.events.Event;

	// refer: http://stackoverflow.com/questions/13696003/easiest-method-to-check-network-status-on-ipad-with-adobe-air
	public class NetStatusEvent extends Event
	{
		public static const  NETWORK_STATUS_CHANGED:String = "networkStatusChanged";
		
		public var status:Boolean;
		
		public function NetStatusEvent(type:String, status:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.status = status;
		}
		
		override public function clone():Event
		{
			return new NetStatusEvent(type, status, bubbles,cancelable);
		}
		
	}
}