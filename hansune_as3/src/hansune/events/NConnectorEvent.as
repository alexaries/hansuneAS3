package hansune.events
{
    import flash.events.Event;
    import flash.net.Socket;
    
    /**
     *  NormalConnector 용 이벤트
     * @author hansoo
     * 
     */
    public class NConnectorEvent extends Event
    {
        
        public static const INITED_SERVER:String = "initedServer";
        
        public static const NEW_CLIENT:String = "newClient";
		
		public static const GONE_CLIENT:String = "goneClient";
        
        public static const CONNECTED_TO_SERVER:String = "connectedToServer";
        
        public static const DISCONNECTED_FROM_SERVER:String = "disconnectedFromServer";
        
        public static const SERVER_DIE:String = "serverDie";
        
        public var client:Socket;
        
        public function NConnectorEvent(type:String, client:Socket = null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.client = client;
        }
		
		override public function clone():Event {
			return new NConnectorEvent(type, client, bubbles, cancelable);
		}
    }
}