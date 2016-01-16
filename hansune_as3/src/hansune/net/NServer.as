package hansune.net
{
    import flash.errors.IOError;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.ServerSocketConnectEvent;
    import flash.net.ServerSocket;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
    import hansune.events.NSocketEvent;
	
    /**
     * 바이트 어레이 데이터가 들어올 경우
	 * 
     */
    [Event(name="data", type="hansune.events.NSocketEvent")]
    
    /**
     * NServer 클라이언트 연결되었을 때 
     */
    [Event(name="clientConnected", type="hansune.events.NSocketEvent")]
    
    /**
     * NServer 클라이언트 연결이 해제 되었을 때
     */
    [Event(name="clientDisconnected", type="hansune.events.NSocketEvent")]
    
    /**
     * NServer 서버가 bind 되었을 경우 
     */
    [Event(name="open", type="flash.events.Event")]
    
    /**
     * 서버가 정지되었을 경우, end 명령에 의해 발생하지는 않으며, 운영체제에서 소켓을 닫을 때 발생
     */
    [Event(name="close", type="flash.events.Event")]
    
    /**
     *에러 이벤트 
     */
    [Event(name="error", type="flash.events.ErrorEvent")]
    
    /**
     * 메시지 전달을 위한 기본 소켓서버,
     * writeUTFBytes, writeBytes 을 사용한다. 
     * @author hansoo
     * 
     */
    public class NServer extends EventDispatcher
    {
        /**
         * 끊어지면 자동연결 할 껀가요? 
         */
        public var autoConnecting:Boolean = true;
        /**
         * whether tracing message or not
         */        
        public static var debug:Boolean = false;
        
        private var _host:String;
        private var _port:uint;
        private var serverSocket:ServerSocket;
        private var clientSockets:Vector.<Socket>;
        
        public function NServer(target:IEventDispatcher=null)
        {
            super(target);
            clientSockets = new Vector.<Socket>();
        }
        
        public function get bound():Boolean {
            return serverSocket.bound;
        }
        
        /**
         * 소켓서버 정지 
         * 
         */
        public function end():void {
            if(serverSocket.bound){
                serverSocket.close();
            }
            var len:int = clientSockets.length;
            for(var i:int = 0; i<len; i++)
            {
                clientSockets[0].close();
                clientSockets[0].removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
                clientSockets[0].removeEventListener(Event.CLOSE, onClientClose);
                clientSockets[0].removeEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
                clientSockets.splice(0,1);
            }
        }
        
        /**
         * 소켓서버를 시작한다. 
         * @param port
         * @param localIp
         * 
         */
        public function bind(port:int, localIp:String):void {
            if(serverSocket != null){
                if(serverSocket.bound){
                    serverSocket.close();
                }
                serverSocket = null;
            }
            serverSocket = new ServerSocket();
            _host = localIp;
            _port = port;
            
            try {
                serverSocket.bind(port, localIp);
                serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
                serverSocket.addEventListener(Event.CLOSE, onClose);
                serverSocket.listen();
                
                
                trace( "Bound to: " + serverSocket.localAddress + ":" + serverSocket.localPort );
            } catch (e:RangeError){
                trace("RangeError : " + e.toString()); 
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false, false, e.name + e.message, e.errorID));
                return;
            } catch (e:IOError){
                trace("IOError : " + e.toString()); 
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false, false, e.name + e.message, e.errorID));
                trace(clientSockets.length);
                return;
            } catch (e:ArgumentError) {
                trace("ArgumentError : " + e.toString()); 
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false, false, e.name + e.message, e.errorID));
                return;
            }
            dispatchEvent(new Event(Event.OPEN));
        }
        
        //close 명령에 의해 발생하지는 않으며, 운영체제에서 소켓을 닫을 때 발생
        private function onClose(e:Event):void {
            dispatchEvent(new Event(Event.CLOSE));
        }
        
        /**
         * 연결되어 있는 모든 클라이언트에게 바이트어레이를 전송
		 * clientSockets[i].writeBytes(bytes);
         * @param bytes
         * @param excepts 제외시킬 소켓
         */
        public function sendBytes(bytes:ByteArray, excepts:Array = null):void {
            if(!serverSocket.bound || !serverSocket.listening) return; 
			var i:int = 0;
            for (i = 0; i < clientSockets.length; i++) 
            {
                if( clientSockets[i] == null || !clientSockets[i].connected )
                {
                    if(clientSockets[i] != null)
                    {
                        clientSockets[i].close();
                        clientSockets[i].removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
                        clientSockets[i].removeEventListener(Event.CLOSE, onClientClose);
                        clientSockets[i].removeEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
                    }
                    clientSockets.splice(i, 1);
                    dispatchEvent(new NSocketEvent(NSocketEvent.CLIENT_DISCONNECTED, null, clientSockets[i]));
                }
            }
            
			if(excepts == null) excepts = [];
			
			for (i = 0; i < clientSockets.length; i++) 
			{
				if( excepts.indexOf(clientSockets[i]) < 0) {
					clientSockets[i].writeBytes(bytes);
					clientSockets[i].flush(); 
				}
			}
            
        }
        
        
        
		/**
		 * 클라이언트에 스트링 데이터 전송<br/>
		 * clientSockets[i].writeUTFBytes(str);
		 * @param str
		 * @param excepts 제외시킬 소켓
		 * 
		 */
        public function send( str:String, excepts:Array = null ):void
        {
            
            if(!serverSocket.bound || !serverSocket.listening) return; 
            
			var i:int;
            for (i = 0; i < clientSockets.length; i++) 
            {
                if( clientSockets[i] == null || !clientSockets[i].connected )
                {
                    if(clientSockets[i] != null)
                    {
                        clientSockets[i].close();
                        clientSockets[i].removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
                        clientSockets[i].removeEventListener(Event.CLOSE, onClientClose);
                        clientSockets[i].removeEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
                    }
                    clientSockets.splice(i, 1);
                    dispatchEvent(new NSocketEvent(NSocketEvent.CLIENT_DISCONNECTED, null, clientSockets[i]));
                }
            }
			
			if(excepts == null) excepts = [];
            
			for (i = 0; i < clientSockets.length; i++) 
			{
				if( excepts.indexOf(clientSockets[i]) < 0) {
					clientSockets[i].writeUTFBytes(str);
					clientSockets[i].flush();
				}
			}
        }
        
        
        private function onConnect( event:ServerSocketConnectEvent ):void
        {
            clientSockets.push(event.socket);
            event.socket.addEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
            event.socket.addEventListener(Event.CLOSE, onClientClose);
            event.socket.addEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
            
            dispatchEvent(new NSocketEvent(NSocketEvent.CLIENT_CONNECTED, null, event.socket));
        }
        
        private function onClientClose(e:Event):void {
            var sock:Socket = e.currentTarget as Socket;
            sock.removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
            sock.removeEventListener(Event.CLOSE, onClientClose);
            sock.removeEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
            var index:int = clientSockets.indexOf(sock);
            if(index > -1)
            {
                clientSockets.splice(index, 1);
            }
            
            dispatchEvent(new NSocketEvent(NSocketEvent.CLIENT_DISCONNECTED, null, sock));
        }
        
        private function onClientIOError(e:Event):void {
            var sock:Socket = e.currentTarget as Socket;
            sock.removeEventListener(ProgressEvent.SOCKET_DATA, onClientSocketData);
            sock.removeEventListener(Event.CLOSE, onClientClose);
            sock.removeEventListener(IOErrorEvent.IO_ERROR, onClientIOError);
            var index:int = clientSockets.indexOf(sock);
            if(index > -1)
            {
                clientSockets.splice(index, 1);
            }
            
            dispatchEvent(new NSocketEvent(NSocketEvent.CLIENT_DISCONNECTED, null, sock));
        }
        
        
        private var buffer:ByteArray = new ByteArray();
		
        private function onClientSocketData( e:ProgressEvent ):void
        {
			var sock:Socket = e.currentTarget as Socket;
			var data:ByteArray = new ByteArray();
			sock.readBytes(data, 0, sock.bytesAvailable);
			
			dispatchEvent(new NSocketEvent(NSocketEvent.DATA, data, sock));
        }
    }
}
