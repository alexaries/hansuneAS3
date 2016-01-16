
package hansune.net
{	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import hansune.events.NSocketEvent;
    
    /**
     *IO 에러 발생시 
     */
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 접속 되었을 때 
	 */
	[Event(name="open", type="flash.events.Event")]
	/**
	 * 연결이 끊어졌을 경우  
	 */
	[Event(name="close", type="flash.events.Event")]
    
    /**
     * 데이터 발생시
     */
    [Event(name="data", type="hansune.events.NSocketEvent")]
    
	
    /**
     * 메시지 전달을 위한 기본 소켓 클라이언트,
     * writeUTFBytes, writeBytes 을 사용한다. 
     * @author hansoo
     * 
     */
    public class NSocket extends EventDispatcher
    {
        
        /**
         * NormalSocket 생성 , 호스트와 포트가 입력되면 바로 접속실행됨.
         * @param host
         * @param port
         */
        public function NSocket(host:String = null, port:uint = 0):void {
            _socket = new Socket();
            configureListeners();
            conntectTimer = new Timer(5000);
            conntectTimer.addEventListener(TimerEvent.TIMER, onTimer);
            
            _host = host;
            _port = port;
            
            if (host && port)  {
                socket.connect(host, port);
            }
        }
        public static var debug:Boolean = false;
        
        private var _host:String;
        private var _port:uint;
        private var conntectTimer:Timer;
        //private var response:String;
        private var _socket:Socket;
        
        /**
         * 끊어지면 자동연결 할 껀가요? 
         */
        public var autoConnecting:Boolean = true;
        
        /**
         * 연결여부 
         * @return 
         * 
         */
        public function get connected():Boolean {
            return _socket.connected;
        }
        
        /**
         * 내부 소켓
         * @return 
         * 
         */
        public function get socket():Socket {
            return _socket;
        }
        
        /**
         * 연결
         */
        public function connect(host:String, port:uint):void {
            if(_socket.connected) return;
            _host = host;
            _port = port;
            
            if (host && port)  {
                _socket.connect(host, port);
            }
        }
        
        /**
         * 종료
         */
        public function end():void
        {
            if(!_socket.connected) return;
            conntectTimer.stop();
            _socket.close();
            
        }
        
        
		/**
		 * 바이트 어레이를 보낸다.
		 * _socket.writeBytes(bytes);
		 * @param bytes
		 * 
		 */
        public function sendBytes(bytes:ByteArray):void {
            if(!_socket.connected) return;
            
            bytes.position = 0;
            _socket.writeBytes(bytes);
            _socket.flush();
        }
        
        /**
         * 문자 데이터 전송
		 *  _socket.writeUTFBytes(str);
         * @param value
         * 
         */
        public function send(str:String):void {
            if(!_socket.connected) return;
            
            _socket.writeUTFBytes(str);
            _socket.flush();
            
            if(debug) trace("normalSocket send:", str);
        }
        
        private function closeHandler(event:Event):void {
            if(autoConnecting)conntectTimer.start();
            this.dispatchEvent(new Event(Event.CLOSE));
        }
        
        private function configureListeners():void {
            _socket.addEventListener(Event.CLOSE, closeHandler);
            _socket.addEventListener(Event.CONNECT, connectHandler);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        }
        private function connectHandler(event:Event):void {
            if(conntectTimer.running) conntectTimer.stop();
            this.dispatchEvent(new Event(Event.OPEN));
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
            if(autoConnecting)conntectTimer.start();
            this.dispatchEvent(event.clone());
        }
        
        private function onTimer(e:Event):void{
            _socket.connect(_host, _port);
            if(debug) trace("try to connect", _host, _port);
        }
        private function securityErrorHandler(event:SecurityErrorEvent):void {
        }
        
        private function socketDataHandler(e:ProgressEvent):void {
            var data:ByteArray = new ByteArray();
            _socket.readBytes(data, 0, _socket.bytesAvailable);
			
			dispatchEvent(new NSocketEvent(NSocketEvent.DATA, data, _socket));
            
        }
    }
}


