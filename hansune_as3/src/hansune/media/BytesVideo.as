package hansune.media
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import hansune.Hansune;
	
	/**
	 * 비디오 시작시
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * 비디오 플레이 완료시
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 파일 로드 완료
	 */
	[Event(name="added", type="flash.events.Event")]
	
	/**
	 * 에러시
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * flv 파일을 로드한 후 플레이 할 수 있다.
	 * @author hyonsoo han
	 * 
	 */
	public class BytesVideo extends Sprite
	{		
		private var pIsPlaying:Boolean;
		private var pIsAlphaZeroStart:Boolean = false;
		private var pVideo:Video;
		private var pBufferTime:Number = 0.1;
		private var streamClient:Object = new Object();
		private var pNetStream:NetStream;
		private var connection_video:NetConnection = new NetConnection();
		
		/**
		 * 디버그 여부, 내부 trace를 표시
		 */
		public var debug:Boolean = false;
		
		/**
		 * 반복 재생할지 여부 
		 */
		public var isLoop:Boolean = true;
		
		/**
		 * 하드웨어 디코더 사용 여부<br> 
		 * play 이전에 지정, 이미 play했다면 release 후 다시 지정해야함.
		 * @return 
		 * 
		 */
		public function get useHardwareDecode():Boolean
		{
			return pUseHardwareDecode;
		}
	
		/**
		 * 하드웨어 디코더 사용 여부<br> 
		 * play 이전에 지정, 이미 play했다면 release 후 다시 지정해야함.
		 * @param value
		 * 
		 */
		public function set useHardwareDecode(value:Boolean):void
		{
			if(pVideo == null) return;
			pUseHardwareDecode = value;
		}
	
		/**
		 * 처음 시작시 알파가 0에서 시작되게 할지 여부
		 * @return 
		 * 
		 */
		public function get isAlphaZeroStart():Boolean
		{
			return pIsAlphaZeroStart;
		}
	
		
		/**
		 * 처음 시작시 알파가 0에서 시작되게 할지 여부
		 * @param value
		 * 
		 */
		public function set isAlphaZeroStart(value:Boolean):void
		{
			pIsAlphaZeroStart = value;
		}
	
		/**
		 * 화면 표시에 사용하는 비디오 객체 
		 */
		public function get video():Video
		{
			return pVideo;
		}
	
		/**
		 * 플레이 중인지 여부 
		 */
		public function get isPlaying():Boolean
		{
			return pIsPlaying;
		}
		
		/**
		 * NetStream 객체, NetStream의 클라이언트를 새로 지정할 때는 내부 클라이언트를 해제하는 것으로 주의해야 함.
		 * @return 
		 * 
		 */
		public function get netStream():NetStream {
			return pNetStream;
		}
		
		private var pUseHardwareDecode:Boolean = false;
		
		private var bytes:ByteArray;
		
		private var pVol:Number = 1;
		
		/**
		 * 볼륨값
		 * @return 0~1 
		 * 
		 */
		public function get volume():Number {
			return pVol;
		}
		
		/**
		 * 볼륨값 지정
		 * @param value 0~1
		 * 
		 */
		public function set volume(value:Number):void {
			pVol = value;
			if(pNetStream != null) {
				pNetStream.soundTransform = new SoundTransform(pVol);
			}
		}
		
		
		/**
		 * BytesVideo 생성자 
		 * @param videoWidth 비디오 가로
		 * @param videoHeight 비디오 세로
		 * 
		 */
		public function BytesVideo(videoWidth:uint = 720, videoHeight:uint = 480) {
			Hansune.copyright();
			pVideo = new Video(videoWidth, videoHeight);
			this.addChild(pVideo);
			video.smoothing = true;
			if(pIsAlphaZeroStart) {
				video.alpha = 0;
			}
			pIsPlaying = false;
		}
		
		
		public function loadFile(url:String):void {
			var ur1:URLRequest = new URLRequest(url);
			var ul1:URLLoader = new URLLoader();
			ul1.dataFormat = URLLoaderDataFormat.BINARY;
			ul1.addEventListener(Event.COMPLETE, loadedFile);
			ul1.addEventListener(IOErrorEvent.IO_ERROR, onIoErr);
			ul1.load(ur1);
		}
		
		private function onIoErr(e:IOErrorEvent):void {
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Unable to locate video: " + e.text, 0));
		}
		
		private function loadedFile(ev:Event):void
		{
			bytes = (ev.currentTarget as URLLoader).data;
			dispatchEvent(new Event(Event.ADDED));
		}
		
		
		/**
		 *  파일 재생
		 * @param url 재생할 파일경로 지정, fileUrl 값이 있으면 인수없이 실행한다.
		 * 
		 */
		public function play():void{
			if(isPlaying) return;
			if(bytes == null) return;
			connectAndPlay_video();
		}
		
		
		/**
		 *일시 정지  
		 * 
		 */
		public function pause():void{
			if(isPlaying){
				pNetStream.pause();
			}
		}
		/**
		 *일시 정지된 파일을 다시 재생 
		 * 
		 */
		public function resume():void {
			if(isPlaying){
				pNetStream.resume();
			}
		}
		
		/**
		 * 비디오 파일 스트리밍 정지, 화면은 그대로 유지
		 */
		public function closeNoClear():void {
			if(pNetStream != null) pNetStream.close();
			if(pIsAlphaZeroStart) video.alpha = 0;
			pIsPlaying = false;
			if(bytes) bytes.clear();
			if(debug) trace("[BytesVideo] closeNoClear");
			
		}
		
		/**
		 *비디오 파일 스트리밍 정지, 화면은 지움.
		 */
		public function close():void {
			if(pNetStream != null) {
				pNetStream.dispose();
			}
			video.clear();
			if(pIsAlphaZeroStart) video.alpha = 0;
			pIsPlaying = false;
			if(bytes) bytes.clear();
			if(debug) trace("[BytesVideo] close");
		}
		
		private function connectAndPlay_video():void
		{
			connection_video.addEventListener(NetStatusEvent.NET_STATUS,netConnectionStatusHandler);
			connection_video.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection_video.connect(null);
		}
		
		
		private function netConnectionStatusHandler(ev:NetStatusEvent):void
		{
			if(debug) trace("[BytesVideo]",ev.info.code);
			switch(ev.info.code)
			{
				case 'NetConnection.Connect.Success':
					if(pNetStream == null) {
						pNetStream = new NetStream(connection_video);
						pNetStream.useHardwareDecoder = pUseHardwareDecode;
						pNetStream.soundTransform = new SoundTransform(pVol);
						streamClient.onMetaData = _onMetaData;
						streamClient.onPlayStatus = _onPlayStatus;
						pNetStream.client = streamClient;
					}
					
					pNetStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatusHandler);
					video.attachNetStream(pNetStream);
					pNetStream.play(null);
					pNetStream.appendBytes(bytes);
					
					pIsPlaying = true;
					
					dispatchEvent(new Event(Event.OPEN));
					
					if(pIsAlphaZeroStart) {
						video.alpha = 0;
						this.addEventListener(Event.ENTER_FRAME,videoAlpha1);
					}
					break;
				case "NetStream.Buffer.Empty" :
					if(isLoop) {
						pNetStream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
						pNetStream.appendBytes(bytes);
					}
					break;
				
				case "NetStream.Buffer.Full" :
					break;
			}
			
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void{
			trace(e.text);
		}
		
		private function videoAlpha1(e:Event):void {
			video.alpha += 0.1;
			if (video.alpha > 1) {
				video.alpha = 1.0;
				this.removeEventListener(Event.ENTER_FRAME,videoAlpha1);
			}
		}
		
		private function asyncErrorHandler(e:AsyncErrorEvent):void{
			trace(e.toString());
		}
		
		private var _duration:Number = 0;
		/**
		 * 재생 시간
		 * @return 
		 * 
		 */
		public function get duration():Number {
			return _duration;
		}
		
		private var _framerate:Number = 0;
		/**
		 * 동영상 프레임 레이트 
		 * @return 
		 * 
		 */
		public function get framerate():Number {
			return _framerate;
		}
		
		private function _onMetaData(info:Object):void {
			//trace("metadata: duration=" + info.duration + " framerate=" + info.framerate);
			_duration = info.duration;
			_framerate = info.framerate;
		}
		
		private function _onPlayStatus(info:Object):void {
			//trace(info);
			switch(info.status) {
				case "NetStream.Play.Switch":
					break;
				case "NetStream.Play.Complete":
					break;
				case "NetStream.Play.TransitionComplete":
					break;
			}
		}
	}
}