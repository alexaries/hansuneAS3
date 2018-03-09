package hansune.media
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import hansune.Hansune;
	import hansune.motion.SooTween;
	
	/**
	 * 비디오 시작시 (루핑되어 시작될 때 발생한다.)
	 * NetStream.Play.Start
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * SecurityErrorEvent
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * AsyncErrorEvent
	 */
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	/**
	 * IOErrorEvent
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 부드러운 반복 동영상 플레이를 플레이 할 수 있다.
	 * @author hansoo
	 * 
	 */
	public class LoopVideo extends Sprite
	{		
		//파일 경로
		private var pFileUrl:String;
		private var pIsPlaying:Boolean;
		private var pVideo1:Video;
		private var pVideo2:Video;
		private var pBufferTime:Number = 0.1;
		private var nowVideo:int;
		private var client:Object = new Object();
		private var pNetStream1:NetStream;
		private var pNetStream2:NetStream;
		private var connection_video1:NetConnection;
		private var connection_video2:NetConnection;
		private var pUseHardwareDecode:Boolean = false;
		
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
			if(pVideo1 == null) return;
			pUseHardwareDecode = value;
		}
		
		/**
		 * 부가정보를 콘솔창에서 볼 수 있다.
		 */
		public var debug:Boolean = false;
		
		/**
		 * 버퍼시간 , 플레이 전에 설정된 값.
		 * @return 
		 * 
		 */
		public function get bufferTime():Number
		{
			return pBufferTime;
		}

		/**
		 * 버퍼시간, 플레이 전에 설정한다.
		 * @param value
		 * 
		 */
		public function set bufferTime(value:Number):void
		{
			pBufferTime = value;
		}
		
		/**
		 * 플레이 중인지 여부 
		 */
		public function get isPlaying():Boolean
		{
			return pIsPlaying;
		}

		/**
		 * 파일 경로 지정
		 * @param url 파일 경로
		 * 
		 */
		public function set fileUrl(url:String):void {
			pFileUrl = url;
		}
		/**
		 * @return 동영상 파일 경로 
		 */
		public function get fileUrl():String {
			return pFileUrl;
		}
		
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
			if(pNetStream1 != null) {
				pNetStream1.soundTransform = new SoundTransform(pVol);
			}
			if(pNetStream2 != null) {
				pNetStream2.soundTransform = new SoundTransform(pVol);
			}
		}
		
		
		/**
		 * LoopVideo 생성자 
		 * 부드러운 반복 동영상 플레이를 플레이 할 수 있다.
		 * @param videoWidth 비디오 가로
		 * @param videoHeight 비디오 세로
		 * 
		 */
		public function LoopVideo(videoWidth:uint = 720, videoHeight:uint = 480){
			
			Hansune.copyright();
			
			pVideo2 = new Video(videoWidth, videoHeight);
			pVideo2.smoothing = true;
			this.addChild(pVideo2);
			
			pVideo1 = new Video(videoWidth, videoHeight);
			pVideo1.smoothing = true;
			this.addChild(pVideo1);
			
			pIsPlaying = false;
		}
		
		/**
		 *  파일 재생
		 * @param url 재생할 파일경로 지정, fileUrl 값이 있으면 인수없이 실행한다.
		 * 
		 */
		public function play(url:String=null):void{
			if(isPlaying) return;
			if(url != null) pFileUrl = url;
			if(pFileUrl == null || pFileUrl.length < 1) return;
			pIsPlaying = true;
			nowVideo = -1;
			connectAndPlay_video();
		}
		
		
		/**
		 *일시 정지  
		 * 
		 */
		public function pause():void{
			if(isPlaying) {
				if(nowVideo == 1) {
					pNetStream1.pause();
				}
				else {
					pNetStream2.pause();
				}
			}
		}
		/**
		 *일시 정지된 파일을 다시 재생 
		 * 
		 */
		public function resume():void {
			if(isPlaying){
				if(nowVideo == 1) {
					pNetStream1.resume();
				}
				else {
					pNetStream2.resume();
				}
			}
		}
		
		/**
		 * 비디오 파일 스트리밍 정지, 화면은 그대로 유지
		 */
		public function closeNoClear():void {
			pIsPlaying = false;
			if(pNetStream1 != null) pNetStream1.close();
			if(pNetStream2 != null) pNetStream2.close();
			nowVideo = -1;
			loopedCount = 0;
			if(debug) trace("[LoopVideo] closeNoClear");
		}
		
		/**
		 *비디오 파일 스트리밍 정지, 화면은 지움.
		 */
		public function close():void {
			pIsPlaying = false;
			
			if(pNetStream1 != null) {
				pNetStream1.dispose();
			}
			if(pNetStream2 != null) {
				pNetStream2.dispose();
			}
			pVideo1.clear();
			pVideo2.clear();
			nowVideo = -1;
			loopedCount = 0;
			if(debug) trace("[LoopVideo] close");
		}
		
		
		
		private function connectAndPlay_video():void
		{
			nowVideo = -1;
			connection_video1 = new NetConnection();
			connection_video1.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler_video);
			connection_video1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection_video1.connect(null);
		}
		
		
		private var isFlush:Boolean = false;
		
		/**
		 * 루핑된 수 
		 */
		public var loopedCount:int = 0;
		
		
		/**
		 * 버퍼에서 Flush가 일어날 경우 미리 다음 스트림을 재생시키고 비디오 객체를 트랜지션 시킬지 여부
		 */
		public var doTransitionAtFlush:Boolean = false;
		
		/**
		 * doTransitionAtFlush 이 true 일때, 트랜지션되는 시간 (초) : 기본 0.8
		 */
		public var transitionTimeAtFlush:Number = 0.8;
		
		/**
		 * doTransitionAtFlush 이 true 일 때, 트랜지션이 일어나는 시간 딜레이(초) 기본 0.7
		 */
		public var transitionDelayAtFlush:Number = 0.7;
		
		private function netStatusHandler_video(event:NetStatusEvent):void {
			if(debug) trace("[LoopVideo]", event.info.code, loopedCount);
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream_video();
					break;
				case "NetStream.Play.StreamNotFound" :
					trace("Unable to locate video: " + pFileUrl);
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Unable to locate video: " + pFileUrl, 0));
					break;
				
				case "NetStream.Buffer.Flush" :
					//trace(_netStream1.bytesLoaded);
					if(doTransitionAtFlush) {
						if(!isFlush) {
							isFlush = true;
							if(nowVideo == 1)
							{
								pNetStream2.resume();
								SooTween.to(pVideo1,transitionTimeAtFlush, {alpha:0, delay:transitionDelayAtFlush, onComplete:video1Off});
								nowVideo = 2;
							}
							else
							{
								pNetStream1.resume();
								pVideo1.alpha = 0;
								pVideo1.visible = true;
								SooTween.to(pVideo1,transitionTimeAtFlush, {alpha:1,  delay:transitionDelayAtFlush});
								nowVideo = 1;
							}
						}
					}
					break;
				case "NetStream.Play.Start" :
					dispatchEvent(new Event(Event.OPEN));
					break;
				
				
				case "NetStream.Play.Stop" :
					if(doTransitionAtFlush) 
					{
						if(nowVideo == 1) {
							pNetStream2.seek(0);
							pNetStream2.pause();
						}
						else {
							pNetStream1.seek(0);
							pNetStream1.pause();
						}
						
						isFlush = false;
					}
					else 
					{
						if(nowVideo == 1)
						{
							pVideo1.visible = false;
							pNetStream1.seek(0);
							pNetStream1.pause();
							
							pNetStream2.resume();
							nowVideo = 2;
						}
						else
						{
							pNetStream2.seek(0);
							pNetStream2.pause();
							
							pVideo1.visible = true;
							pNetStream1.resume();
							nowVideo = 1;
						}
					}
					
					
					loopedCount ++;
					
					break;
			}			
		}
		
		private function video1Off():void {
			
			pVideo1.visible = false;
		}
		
		private function connectStream_video():void {
			
			
			if(nowVideo == -1)
			{
				if(pNetStream1 == null) {
					pNetStream1 = new NetStream(connection_video1);
					pNetStream1.client = client;
					pNetStream1.useHardwareDecoder = pUseHardwareDecode;
					pNetStream1.soundTransform = new SoundTransform(pVol);
					client.onMetaData = _onMetaData;
					client.onPlayStatus = _onPlayStatus;
					pNetStream1.client = client;
				}
				pNetStream1.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler_video);
				pNetStream1.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				pNetStream1.bufferTime = pBufferTime;
				
				nowVideo = 0;
				connection_video2 = new NetConnection();
				connection_video2.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler_video);
				connection_video2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection_video2.connect(null);
				
			}
			else if(nowVideo == 0)
			{
				connectStream_video2();
				
			}
		}
		
		private function connectStream_video2():void {
			if(pNetStream2 == null) {
				pNetStream2 = new NetStream(connection_video2);
				pNetStream2.useHardwareDecoder = pUseHardwareDecode;
				pNetStream2.soundTransform = new SoundTransform(pVol);
			}
			pNetStream2.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler_video);
			pNetStream2.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			pNetStream2.client = client;
			pNetStream2.bufferTime = pBufferTime;
			
			pNetStream2.play(pFileUrl);
			pNetStream2.pause();
			pVideo2.attachNetStream(pNetStream2);
			
			pVideo1.visible = true;
			pVideo1.attachNetStream(pNetStream1);
			pNetStream1.play(pFileUrl);
			
			nowVideo = 1;
			
		}
		
		
		private function securityErrorHandler(e:SecurityErrorEvent):void{
			trace(e.text);
			dispatchEvent(e.clone());
		}
		
		private function asyncErrorHandler(e:AsyncErrorEvent):void{
			trace(e.toString());
			dispatchEvent(e.clone());
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
		
		/*
		NetStream.Play.Switch	"status"	The subscriber is switching from one stream to another in a playlist.
		NetStream.Play.Complete	"status"	Playback has completed.
		NetStream.Play.TransitionComplete	"status"	The subscriber is switching to a new stream as a result of stream bit-rate switching
		*/
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