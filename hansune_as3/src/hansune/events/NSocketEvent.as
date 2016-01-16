package hansune.events
{
    import flash.events.Event;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
	/**
	 * NormalServer 에서 발생시키는 이벤트
	 * @author hyonsoohan
	 * 
	 */
    public class NSocketEvent extends Event
    {
		/**
		 * 데이터 발생
		 */
        static public const DATA:String = "data";
        
		/**
		 * 클라이언트 접속
		 */
        static public const CLIENT_CONNECTED:String = "clientConnected";
        
        /**
         * 클라이언트가 접속이 해제됨.
         */
        static public const CLIENT_DISCONNECTED:String = "clientDisconnected";
        
		/**
		 * 클라이언트 소켓
		 */
        public var socket:Socket;
		
		/**
		 * 바이트 데이터
		 */
		public var data:ByteArray;
		
        public function NSocketEvent(type:String, data:ByteArray = null, socket:Socket = null)
        {
            super(type, false, false);
            this.data = data;
            this.socket = socket;
        }
		
		override public function clone():Event {
			return new NSocketEvent(type, data, socket);
		}
    }
}