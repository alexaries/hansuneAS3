package hansune.media
{
	import flash.display.BitmapData;
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
	
	/**
	 * 비디오 시작시
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * 비디오 플레이 완료시
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 에러시
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 비디오가 끝나간다는 신호, closingTime 이 남았을 경우 발생
	 * 에어에서만 작동함
	 */
	[Event(name="closing", type="flash.events.Event")]
	
	
	/**
	 * 플레이의 현재시간을 알고 싶을 때
	 */
	[Event(name="change", type="flash.events.Event")]
	
	
	
	/**
	 * play, pause, close 등의 명령만으로  간단히 비디오 파일을 플레이 할 수 있다.
	 * @author hyonsoo han
	 * 
	 */
	public class SimpleVideo extends Sprite
	{		
		private var pFileUrl:String;//파일 경로
		private var pIsPlaying:Boolean;
		private var pIsAlphaZeroStart:Boolean = false;
		private var pVideo:Video;
		private var pBufferTime:uint = 0.1;
		private var connection_video:NetConnection = new NetConnection();
		private var pNetStream:NetStream;
		private var _loop:Boolean = false;
		private var pIsPaused:Boolean = false;
		
		public var streamClient:Object;;
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if(type == Event.CHANGE) {
				isPlayTimeEvent = true;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if(type == Event.CHANGE) {
				isPlayTimeEvent = false;
			}
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 플레이 타임
		 * @return 초
		 * 
		 */
		public function get time():Number {
			if(pNetStream == null) return 0;
			return pNetStream.time;
		}
		
		/**
		 * 플레이 퍼센트
		 * @return 
		 * 
		 */
		public function get timePercent():Number {
			if(pNetStream == null) return 0;
			return (pNetStream.time / duration) * 100;
		}
		
		/**
		 * 디버그 여부, 내부 trace를 표시
		 */
		public var debug:Boolean = false;
		
		/**
		 * 반복 재생
		 * @param value
		 * 
		 */
		public function set loop(value:Boolean):void {
			_loop = value;
		}
		
		/**
		 * 반복 재생
		 * @return 
		 * 
		 */
		public function get loop():Boolean {
			return _loop;
		}
		
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
		 * 버퍼시간, 플레이 전에 설정
		 * @return 
		 * 
		 */
		public function get bufferTime():uint
		{
			return pBufferTime;
		}
		/**
		 * 버퍼시간, 플레이 전에 설정
		 * @return 
		 * 
		 */
		public function set bufferTime(value:uint):void
		{
			pBufferTime = value;
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
		 * 플레이 중인지 여부, pause 상태도 플레이 중이다
		 */
		public function get isPlaying():Boolean
		{
			return pIsPlaying;
		}
		
		/**
		 * 일시정지 중인지 여부
		 * @return 
		 * 
		 */
		public function get isPaused():Boolean {
			return pIsPaused;
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
		
		/**
		 * NetStream 객체, NetStream의 클라이언트를 새로 지정할 때는 내부 클라이언트를 해제하는 것으로 주의해야 함.
		 * @return 
		 * 
		 */
		public function get netStream():NetStream {
			return pNetStream;
		}
		
		/**
		 * Closing 이벤트를 보내는 타이밍. 동영상이 끝나기 이 시간전에 이벤트를 발생한다. 초단위.
		 */
		public var closingTime:Number = 1;	
	
		private var pUseHardwareDecode:Boolean = false;
		
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
		 * SimpleVideo 생성자 
		 * @param videoWidth 비디오 가로
		 * @param videoHeight 비디오 세로
		 * 
		 */
		public function SimpleVideo(videoWidth:uint = 720, videoHeight:uint = 480) {
			Hansune.copyright();
			pVideo = new Video(videoWidth, videoHeight);
			this.addChild(pVideo);
			video.smoothing = true;
			if(pIsAlphaZeroStart) {
				video.alpha = 0;
			}
			pIsPlaying = false;
		}
		
		/**
		 *  파일 재생
		 * @param url 재생할 파일경로 지정, fileUrl 값이 있으면 인수없이 실행한다.
		 * 
		 */
		public function play(url:String=null):void{
			
			if(isReady) {
				if(isReadyDone) {
					isReady = false;
					isReadyDone = false;
					trace(name, "[SimpleVideo] ready and resume");
					resume();
					
				}
				return;
			}
			
			if(pNetStream != null) {
				pNetStream.resume();
				this.addEventListener(Event.ENTER_FRAME, onCheckTime);
			}
			if(isPlaying) return;
			if(url != null) pFileUrl = url;
			if(pFileUrl == null || pFileUrl.length < 1) return;
			
			pIsPlaying = true;
			isCheckDuration = false;
			closingEvented = false;
			
			
			connectAndPlay_video();
			
			
			this.addEventListener(Event.ENTER_FRAME, onCheckTime);
			
		}
		
		private var isReady:Boolean = false;
		private var isReadyDone:Boolean = false;
		public function ready(url:String = null):void {
			if(pNetStream != null) {
				closeNoClear();
			}
			if(isPlaying) return;
			if(url != null) pFileUrl = url;
			if(pFileUrl == null || pFileUrl.length < 1) return;
			
			pIsPlaying = true;
			
			isReady = true;
			isReadyDone = false;
			isCheckDuration = false;
			closingEvented = false;
			connectAndPlay_video();
			this.addEventListener(Event.ENTER_FRAME, onCheckTime);
		}
		
		
		private var isSeeking:Boolean = false;
		/**
		 * pNetStream.seek(offset);
		 * @param offset
		 * 
		 */
		public function seek(offset:Number):void {
			if(isPlaying && !isSeeking) {
				isSeeking = true;
				offset = Math.min(duration, Math.max(0, offset));
				pNetStream.seek(offset);
			}
		}
		
		/**
		 *일시 정지  
		 * 
		 */
		public function pause():void{
			if(isPlaying && !pIsPaused){
				if(debug) trace(name + " [SimpleVideo] pause", fileUrl);
				pNetStream.pause();
				this.removeEventListener(Event.ENTER_FRAME, onCheckTime);
			}
		}
		/**
		 *일시 정지된 파일을 다시 재생 
		 * 
		 */
		public function resume():void {
			if(debug) trace(name + " [SimpleVideo] resume", isPlaying, pIsPaused);
			if(isPlaying && pIsPaused){
				if(debug) trace(name + " [SimpleVideo] resume", fileUrl);
				pNetStream.resume();
				this.addEventListener(Event.ENTER_FRAME, onCheckTime);
			}
		}
		
		/**
		 * 비디오 파일 스트리밍 정지, 화면은 그대로 유지
		 */
		public function closeNoClear():void {
			internalClose()
			if(debug) trace(name + " [SimpleVideo] closeNoClear");
		}
		
		/**
		 *비디오 파일 스트리밍 정지, 화면은 지움.
		 */
		public function close():void {
			internalClose();
			if(debug) trace(name + " [SimpleVideo] close");
			video.clear();
		}
		
		
		private function internalClose():void {
			if(pNetStream != null) pNetStream.dispose();
			pNetStream = null;
			pIsPlaying = false;
			isReady = false;
			isReadyDone = false;
			this.removeEventListener(Event.ENTER_FRAME, onCheckTime);
		}
		
		
		/**
		 * 현재 비디오 이미지 추출
		 * @return 비트맵
		 * 
		 */
		public function capture():BitmapData {
			if(video != null) {
				var bd:BitmapData = new BitmapData(video.width, video.height);
				bd.draw(video);
				
				return bd;
			}
			
			return null;
		}
		
		
		private function connectAndPlay_video():void
		{
			connection_video.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler_video);
			connection_video.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection_video.connect(null);
		}
		
		private function netStatusHandler_video(event:NetStatusEvent):void {
			
			//if(debug) trace(name + " [SimpleVideo]", event.info.code);
			
			switch (event.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream_video();
					break;
				
				case "NetConnection.Connect.Closed" : 
					break;
				
				case "NetStream.Play.StreamNotFound" :
					trace("Unable to locate video: " + pFileUrl);
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Unable to locate video: " + pFileUrl, 0));
					break;
				case "NetStream.Play.Start" :
					if(isReady) {
						if(debug) trace(name , "[SimpleVideo]", "ready", fileUrl);
						isReadyDone = true;
						pause();
					}
					else {
						if(debug) trace(name , "[SimpleVideo]", "play", fileUrl);
						dispatchEvent(new Event(Event.OPEN));
					}
					break;
				
				case "NetStream.Play.Stop" :
					
					if(loop){
						pNetStream.seek(0);
					} else {
						pause();
					}
					
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				
				case "NetStream.Buffer.Full" :
					trace(name , "[SimpleVideo]", "buffer full", fileUrl);
					break;
				
				case "NetStream.SeekStart.Notify" :
					isSeeking = true;
					break;
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime" :
				case "NetStream.Seek.Notify" :
				case "NetStream.Seek.Complete" :
					isSeeking = false;
					break;
				
				case "NetStream.Pause.Notify" :
					pIsPaused = true;
					break;
				
				case "NetStream.Unpause.Notify" :
					pIsPaused = false;
					break;
			}			
		}
		
		
		private function connectStream_video():void {
			if(pNetStream == null) {
				pNetStream = new NetStream(connection_video);
				pNetStream.useHardwareDecoder = pUseHardwareDecode;
				pNetStream.soundTransform = new SoundTransform(pVol);
				if(streamClient == null) {
					streamClient = new Object();
					streamClient.onMetaData = _onMetaData;
					streamClient.onPlayStatus = _onPlayStatus;
				}
				pNetStream.client = streamClient;
				
			}
			
			pNetStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler_video);
			pNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			pNetStream.bufferTime = pBufferTime;
			video.attachNetStream(pNetStream);
			
			if(pIsAlphaZeroStart) {
				video.alpha = 0;
				this.addEventListener(Event.ENTER_FRAME,videoAlpha1);
			}
			
			pNetStream.play(pFileUrl);
			
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
		 * 동영상 총 시간
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
		
		private var isCheckDuration:Boolean = false;
		private var closingEvented:Boolean = false;
		private var isPlayTimeEvent:Boolean = false;
		private function _onMetaData(info:Object):void {
			if(debug) trace(name + " metadata: duration=" + info.duration + " framerate=" + info.framerate);
			_duration = info.duration;
			_framerate = info.framerate;
			if(info.duration) {
				isCheckDuration = true;
			}
		}
		
		/**
		 * changeEvent 를 보내는 딜레이(frame) 
		 */
		protected var changeEventDelay:int = 2;
		private var changeEventCnt:int = 0;
		
		
		private function onCheckTime(e:Event):void {
			if(isCheckDuration && !closingEvented) {
				if(pNetStream.time > _duration - closingTime) {
					closingEvented = true;
					dispatchEvent(new Event("closing"));
				}
			}
			
			changeEventCnt++;
			if(isPlayTimeEvent && pNetStream != null && isCheckDuration && changeEventCnt > changeEventDelay) {
				dispatchEvent(new Event(Event.CHANGE));
				changeEventCnt = 0;
			}
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