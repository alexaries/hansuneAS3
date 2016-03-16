package hansune.net
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import air.net.URLMonitor;
	
	import hansune.events.NetStatusEvent;
	
	[Event(name="networkStatusChanged", type="flash.events.Event")]
	
	// refer: http://stackoverflow.com/questions/13696003/easiest-method-to-check-network-status-on-ipad-with-adobe-air
	public class NetStatusMonitor extends EventDispatcher
	{
		private var urlMonitor:URLMonitor;
		private var url:String;
		
		public function NetStatusMonitor(url:String = 'http://www.google.com')
		{
			super();
			this.url = url;
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetwork_ChangeHandler);
		}
		
		protected function onNetwork_ChangeHandler(event:Event):void
		{
			start();
		}       
		
		public function start():void
		{
			urlMonitor = new URLMonitor(new URLRequest(url));
			urlMonitor.addEventListener(StatusEvent.STATUS, onNetStatus_ChangeHandler);
			
			if(!urlMonitor.running)
				urlMonitor.start();
		}
		
		public function stop():void
		{
			if(urlMonitor.running)
				urlMonitor.stop();
		}
		
		private function onNetStatus_ChangeHandler(event:StatusEvent):void
		{
			trace("event code " + event.code);
			trace("event level " + event.level);
			dispatchEvent(new NetStatusEvent(NetStatusEvent.NETWORK_STATUS_CHANGED,urlMonitor.available));
			stop();
		}
	}
}