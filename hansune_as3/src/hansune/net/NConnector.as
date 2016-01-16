package hansune.net
{
    
    import flash.desktop.NativeApplication;
    import flash.display.DisplayObjectContainer;
    import flash.events.DataEvent;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.ServerSocketConnectEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    
    import hansune.Hansune;
    import hansune.events.NSocketEvent;
    import hansune.events.NConnectorEvent;
    import hansune.net.IConnectorParser;
    import hansune.net.NSocket;
    import hansune.ui.SimpleDialog;
    
	/**
	 * 외부 클라이언트가 내부 서버에서 떨어졌을 때
	 */
	[Event(name="newClient", type="hansune.events.NConnectorEvent")]
    
    /**
     * 내부 클라이언트가 외부 서버에 접속되었을 때
     */
    [Event(name="connectedToServer", type="hansune.events.NConnectorEvent")]
    
    /**
     * 내부 서버가 시작되었을 때
     */
    [Event(name="initedServer", type="hansune.events.NConnectorEvent")]
    
    /**
     * 내부 클라이언트가 외부서버로부터 해제되었을 때 
     */
    [Event(name="disconnectedFromServer", type="hansune.events.NConnectorEvent")]
    
    /**
     * <p>
     * 메시지 전달을 위한 소켓서버와 클라이언트 연결을 내부수행한다. <br/>
     * NormalSocket 과 NormalServer 를 합쳐 놓은 것,<br/>
     * 서버로 작동할 수도 있고, 클라이언트로, 두가지다 작동되게 할 수도 있다.<br/>
	 * NormalConnector 는 아래와 같은 프로토콜로 데이터를 감싸서 전달되어지므로, NormalConnector로 보내고 받는 것이 바람직하다.<br/>
	 * <code>헤드 : (]-[)3bytes + (길이)4bytes + (r+w)3bytes + (tokenID)4 bytes + (data)</code><br/>
	 * <br/>
     * <br/>
     * 데이터를 확인하려면, IConnectorParser 를 연결하여 확인한다.<br/>
     * <code>
     * class SomeObj implements IConnectorParser {<br/>
     * ...<br/>
     * }
     * <br/>
     * var object:SomeObj = new SomeObj();<br/>
     * 
     * var con:NConnector = new NConnector();<br/>
     * con.parser = object;<br/>
     * </code>
     * <br/>
     * 데이터가 넘어오면 IConnectorParser 를 구현한 메소드로 연결된다.<br/>
     * function stringDataFromConnector(msg:String, from:Socket = null):void;<br/>
     * function rawDataFromConnector(bytes:ByteArray, from:Socket = null, tokenID:int = 10):void;
     * </p>
     * @author hansoo
     * 
     */
    public class NConnector extends EventDispatcher
    {
        /**
         *서버 
         */
        public static const SERVER:int = 1;
        /**
         *클라이언트 
         */
        public static const CLIENT:int = 2;
        
        /**
         * 초당 데이터를 전달하는 횟수 
         */
        public var sendAtSecond:int = 10;
        
        /**
         * 디버그 모드 설정, true 이면 오류나 접속 정보를 다이어로그로 보여준다.
         */
        public function get debug():Boolean
        {
            return _debug;
        }
        
        /**
         * 디버그 모드 사용 여부
         * @param value
         * 
         */
        public function set debug(value:Boolean):void
        {
            _debug = value;
            if(client != null) NSocket.debug = value;
            if(server != null) NServer.debug = value;
        }
        
        private var _debug:Boolean = false;
        
        /**
         * 원격으로부터 데이터가 전달되면, 호출하는 인터페이스 구현부를 지정한다.
         * <code>IConnectorParser</code>를 꼭 구현해야 한다.<br/>
         * <code>
         * function stringDataFromConnector(msg:String, from:Socket = null):void;
         * function rawDataFromConnector(bytes:ByteArray, from:Socket = null):void;</code>
         * @param p
         * 
         */
        public function set parser(p:IConnectorParser):void {
            connectorParser = p;
        }
        
        //클라이언트
        private var client:NSocket;
        // 서버
        private var server:NServer;
        // 파서
        private var connectorParser:IConnectorParser;
        //서버, 클라이언트 타입
        private var type:int = 0;
        //오브젝트 데이터 전달 스레드 ID
        private var sender:Number;
		
        //데이터 전송 버퍼
        private var threadBuffer:Array;
        
        
        /**
         * NormalConnector 생성자, 
         * 
         */
        public function NConnector(){	
            Hansune.copyright();
			threadBuffer = new Array();
        }
        
        /**
         * 연결 종료
         * 
         */
        public function closeAll():void {
            if(server != null) server.end();
            if(client != null) client.end();
            clearInterval(sender);
        }
        
        /**
         * 내부 클라이언트
         * @return 
         * 
         */
        public function getClient():NSocket {
            return client;
        }
        
        /**
         * 내부 서버 
         * @return 
         * 
         */
        public function getServer():NServer {
            return server;
        }
        
        /**
         * 서버로 작동 
         * @param ip
         * @param port
         * 
         */
        public function runAsServer(ip:String, port:uint):void {
            type = SERVER;
            server = new NServer();
			server.addEventListener(NSocketEvent.DATA, parseData);
            server.addEventListener(NSocketEvent.CLIENT_CONNECTED, onServerConnected);
			server.addEventListener(NSocketEvent.CLIENT_DISCONNECTED, onServerDisconnected);
            server.addEventListener(Event.INIT, onServerInit);
            server.addEventListener(ErrorEvent.ERROR, onServerError);
            server.addEventListener(Event.CLOSE, onServerClose);
            
            server.bind(port, ip);
            
            sender = setInterval(internalSend, 1000 / sendAtSecond);
        }
		
		/**
		 * 클라이언트로 실행 
		 * @param ip
		 * @param port
		 * 
		 */
		public function runAsClient(ip:String, port:uint):void {
			type = CLIENT;
			
			client = new NSocket(ip, port);
			client.addEventListener(Event.INIT, onClientConnect);
			client.addEventListener(Event.CLOSE, onClientClose);
			client.addEventListener(NSocketEvent.DATA, parseData);
			client.addEventListener(IOErrorEvent.IO_ERROR, onClientIOErr);
			sender = setInterval(internalSend, 1000 / sendAtSecond);
		}
        
        private function internalSend():void {
            
            if(threadBuffer.length < 1) {
                return;
            }
            
			var con:NormalConnectorData = threadBuffer.shift();
			if(con.type == NConnectorData.STR) {
				
				switch(type){
					case SERVER:
						if(con.except == null) server.sendBytes(con.raw);
						else server.sendBytes(con.raw, [con.except]);
						break;
					
					case CLIENT:
						client.sendBytes(con.raw);
						break;
				}
			}
			else {
				switch(type){
					case SERVER:
						if(con.except == null) server.sendBytes(con.raw);
						else server.sendBytes(con.raw, [con.except]);
						break;
					
					case CLIENT:
						client.sendBytes(con.raw);
						break;
					}
				}			
        }
        
        
        /**
         * 모든 클라이언트에 텍스트 정보 전달, 
         * @param data
         * @param useServer Both 작동시 서버에서 보낼지 여부, 버퍼링에 남아 있는 것들도 적용됨
         * 
         */
        public function send(str:String):void {
			threadBuffer.push(new NormalConnectorData(NConnectorData.STR, str, 0));
        }
        
        /**
         * 지정 소켓으로 직접 보냄 , writeUTFBytes
         * @param str
         * @param socket
         * 
         */
        public function sendDirect(str:String, socket:Socket):void {
            if( socket != null && socket.connected )
            {
				var raw:ByteArray = new ByteArray();
				var bytes:ByteArray = new ByteArray();
				bytes.writeUTFBytes(str);
				bytes.position = 0;
				raw.writeUTFBytes(NConnectorData.HEAD);
				raw.writeInt(3 + 4 + bytes.length);
				raw.writeUTFBytes(NConnectorData.STR);//헤드설정
				raw.writeInt(10);
				raw.writeBytes(bytes, 0, bytes.bytesAvailable);
				
				socket.writeBytes(raw);
				socket.flush(); 
                if(debug) trace( "sendDirect to " + socket.remoteAddress, "[", str, "]");
            }
        }
		
		/**
		 *  지정 소켓을 제외한 모든 클라이언트에 텍스트 정보 전달, 
		 * @param str
		 * @param socket
		 * 
		 */
		public function sendExcept(str:String, socket:Socket):void {
			threadBuffer.push(new NormalConnectorData(NConnectorData.STR, str, 0, socket));
		}
		
		
		/**
		 * 지정 소켓을 제외한 모든 클라이언트에 바이트 전달, 
		 * @param bytes
		 * @param socket
		 * @param tokenID
		 * 
		 */
		public function sendRawExcept(bytes:ByteArray, socket:Socket, tokenID:int = 10):void {
			threadBuffer.push(new NormalConnectorData(NConnectorData.RAW, bytes, tokenID, socket));
		}
		
		/**
		 * 지정 소켓으로 바이트를 직접 보냄 , writeBytes
		 * @param bytes 보낼 바이트
		 * @param socket 대상 소켓
		 * @param tokenID 토큰 아이디
		 * 
		 */
		public function sendRawDirect(bytes:ByteArray, socket:Socket, tokenID:int = 10):void {
			if( socket != null && socket.connected )
			{
				var raw:ByteArray = new ByteArray();
				raw.writeUTFBytes(NConnectorData.HEAD);
				raw.writeInt(3 + 4 + bytes.length);
				raw.writeUTFBytes(NConnectorData.RAW);//바이트어레이로 보낸다는 헤드설정
				raw.writeInt(tokenID);
				raw.writeBytes(bytes);
				
				socket.writeBytes(raw);
				socket.flush(); 
				if(debug) trace( "sendRawDirect to " + socket.remoteAddress, "[", tokenID, "]");
			}
		}
        
		/**
		 * 모든 클라이언트에 바이트어레이로 보낸다는 헤드설정 후 바이트 보냄
		 * @param bytes
		 * @param tokenID 데이터 구분을 위한 아이디
		 * @see 
		 */
        public function sendRaw(bytes:ByteArray, tokenID:int = 10):void {
			threadBuffer.push(new NormalConnectorData(NConnectorData.RAW, bytes, tokenID));
        }
        
        private function onServerInit(e:Event):void {
            if(debug) trace("NormalServer : 준비됨");
            dispatchEvent(new NConnectorEvent(NConnectorEvent.INITED_SERVER));
        }
        
        private function onServerConnected(e:NSocketEvent):void {
            
            dispatchEvent(new NConnectorEvent(NConnectorEvent.NEW_CLIENT, e.socket));
            
            var txt:String = "NormalServer : 클라이언트 접속"; 
            trace(txt);
            if(debug
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
        }
		
		private function onServerDisconnected(e:NSocketEvent):void {
			
			dispatchEvent(new NConnectorEvent(NConnectorEvent.GONE_CLIENT, e.socket));
			
			var txt:String = "NormalServer : 클라이언트 해제"; 
			trace(txt);
			if(debug
				&& NativeApplication.nativeApplication.activeWindow != null
				&& NativeApplication.nativeApplication.activeWindow.stage != null)
				SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
		}
        
        private function onServerError(e:ErrorEvent):void {
            var txt:String ="NormalServer : 서버 오류 : " + e.text; 
            trace(txt);
            if(debug 
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
            
        }
        
        private function onServerClose(e:Event):void {
            //trace("NormalServer : 서버 정지");
            var txt:String = "NormalServer : 서버 정지"; 
            trace(txt);
            if(debug 
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
        }
        
        
        private function onClientIOErr(e:IOErrorEvent):void {
            var txt:String = "NormalConnector: onClientIOErr :" + e.text; 
            if(debug 
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
        }
        
        private function onClientConnect(e:Event):void {
            var txt:String = "NormalConnector: onClientConnect : 서버접속"; 
            if(debug 
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
            
            dispatchEvent(new NConnectorEvent(NConnectorEvent.CONNECTED_TO_SERVER));
        }
        
        private function onClientClose(e:Event):void {
            var txt:String = "NormalConnector: onClientClose : 서버접속 해제"; 
            if(debug 
                && NativeApplication.nativeApplication.activeWindow != null
                && NativeApplication.nativeApplication.activeWindow.stage != null)
                SimpleDialog.show(NativeApplication.nativeApplication.activeWindow.stage, txt, true, 5000);
            
            dispatchEvent(new NConnectorEvent(NConnectorEvent.DISCONNECTED_FROM_SERVER));
        }
		
		private var isHead:Boolean = false;
		private var buffer:ByteArray = new ByteArray();
		private var partialRecord:Boolean = false;
		private function parseData(e:NSocketEvent):void
		{
			var data:ByteArray = new ByteArray();
			if(partialRecord)
			{
				buffer.readBytes(data, 0, buffer.length);
				partialRecord = false;
			}
			
			e.data.readBytes(data, data.length, e.data.bytesAvailable);
			
			var lengthToRead:int;
			//헤드 : (]-[)3bytes + (길이)4bytes + (s+r)3bytes + (tokenID)4 bytes + (data)
			while(data.position < data.length){
				
				//헤드 검사 ]=[
				if (data.bytesAvailable >= 3) {
					var header:String = data.readUTFBytes(3);
					data.position -= 3;
					if (header == NConnectorData.HEAD) {
						isHead = true;
					} else {
						isHead = false;
					}
				} else {
					isHead = false;
				}       
				
				if(isHead)//패킷 헤드이면
				{
					if(data.bytesAvailable > 7)//7바이트보다 크면  size  정보가 있다
					{
						data.position += 3;//헤더를 건너뛰고
						if(data.readUTFBytes(3) != NConnectorData.HEAD)
						{
							data.position -= 3;
							lengthToRead = data.readInt() + 7;
							data.position -= 7;
						}
							//바로 또 헤더가 있다면 3바이트를 읽어서 떼어버림.
						else
						{
							data.position -= 6;
							lengthToRead = 3;
						}
						
					}
					else //7바이트 이하라면 깨진데이터
					{
						lengthToRead = data.length + 1;
					}
				}
				else //헤드가 아니라면..?
				{
					lengthToRead = data.readInt() + 1;
					data.position -= 4;
				}
				
				//헤드 : (]-[)3bytes + (길이)4bytes + (s+r)3bytes + (tokenID)4 bytes + (data)
				if(lengthToRead <= data.length - data.position)
				{
					var packet:ByteArray = new ByteArray();
					data.readBytes(packet, 0, lengthToRead);
					
					if(packet.length > 14) { 
						
						packet.readUTFBytes(3);//ommit HEAD 3
						packet.readInt();//ommit size 4
						var type:String = packet.readUTFBytes(3); //3
						var tokenID:int = packet.readInt(); // 4
						if(type == NConnectorData.RAW)
						{
							var split:ByteArray = new ByteArray();
							packet.readBytes(split, 0, packet.bytesAvailable);
							split.position = 0;
							
							//dispatchEvent(new hansune.events.NSocketEvent(hansune.events.NSocketEvent.RAW_DATA, "", _socket, split, tokenID));
							if(connectorParser!= null)
							{
								connectorParser.rawDataFromConnector(split, e.socket, tokenID);
							}
						}
						else
						{
							//dispatchEvent(new hansune.events.NSocketEvent(hansune.events.NSocketEvent.STRING_DATA, packet.readUTFBytes(packet.bytesAvailable), _socket, null, 10));
							if(connectorParser != null)
							{
								connectorParser.stringDataFromConnector(packet.readUTFBytes(packet.bytesAvailable), e.socket);
							}
						}
						
					}
				}
				else
				{
					buffer = new ByteArray();
					data.readBytes(buffer, 0, data.length - data.position);
					partialRecord = true;
				}
				
			}//trace("loop off");
		}
    }
}

import flash.net.Socket;
import flash.utils.ByteArray;

import hansune.net.NConnectorData;

internal class NormalConnectorData {
	
	public var raw:ByteArray;
	public var type:String;
	public var str:String;
	public var except:Socket;
	
	public function NormalConnectorData(type:String, data:*, tokenID:int, except:Socket = null) {
		
		raw = new ByteArray();
		this.type = type;
		this.except = except;
		
		//헤드 : (]-[)3bytes + (길이)4bytes + (s+r)3bytes + (tokenID)4 bytes + (data)
		if(this.type == NConnectorData.STR)
		{
			str = data;
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			bytes.position = 0;
			raw.writeUTFBytes(NConnectorData.HEAD);
			raw.writeInt(3 + 4 + bytes.length);
			raw.writeUTFBytes(NConnectorData.STR);//헤드설정
			raw.writeInt(tokenID);
			raw.writeBytes(bytes);
		}
		else
		{
			raw.writeUTFBytes(NConnectorData.HEAD);
			raw.writeInt(3 + 4 + data.length);
			raw.writeUTFBytes(NConnectorData.RAW);//바이트어레이로 보낸다는 헤드설정
			raw.writeInt(tokenID);
			raw.writeBytes(data);
		}
	}
}