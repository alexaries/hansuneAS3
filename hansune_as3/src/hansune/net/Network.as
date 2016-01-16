package hansune.net
{
    import flash.desktop.NativeApplication;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.Timer;
    
    import hansune.events.NetworkEvent;

    /**
     * 네트워크 연결 확인 이벤트 
     */
    [Event(name="change", type="wiot.event.NetworkEvent")]
    
    public class Network
    {
        private static var pingUrl:String = "";
        private static var monitor:EventDispatcher;
		private static var timer:Timer;
		
		public static var isOnline:Boolean = false;
		
        
        public static function init(pingUrl:String):void {
            Network.pingUrl = pingUrl;
            monitor = new EventDispatcher();
            NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, change);
			timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			ping();
        }
		
		private static function onTimer(e:TimerEvent):void {
			ping();
		}
        
        private static function change(e:Event):void {
            ping();
        }
        
        private static var pingReq:URLRequest;
        private static var pingLoader:URLLoader;
        
        public static function ping():void {
            if(pingLoader == null)
            {
                pingReq = new URLRequest();
                pingReq.method = URLRequestMethod.HEAD;
                pingReq.url = pingUrl;
                
                pingLoader = new URLLoader();
                pingLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, pingComplete);
                pingLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void{});
            }
            pingLoader.load(pingReq);
			//trace("ping");
        }
        
        private static function pingComplete(e:HTTPStatusEvent):void {
            if(e.status == 0)
            {
                dispatchEvent(new NetworkEvent(NetworkEvent.CHANGE, false));
				isOnline = false;
            }
            else
            {
                dispatchEvent(new NetworkEvent(NetworkEvent.CHANGE, true));
				isOnline = true;
            }
			//trace("pingComplete");
        }
        
        static public function hasEventListener(type:String):Boolean {
            return monitor.hasEventListener(type);
        }
        
        static public function willTrigger(type:String):Boolean {
            return monitor.willTrigger(type);
        }
        
        static public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            monitor.addEventListener.apply(null, arguments);
        }
        
        static public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            monitor.removeEventListener.apply(null, arguments);
        }
        
        static public function dispatchEvent(event:Event):Boolean {
            return monitor.dispatchEvent.apply(null, arguments);
        }
        
        public function Network()
        {
        }
    }
}