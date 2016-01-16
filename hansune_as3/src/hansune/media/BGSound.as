//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

package hansune.media
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * 파일 로드 오류
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 플레이 끝에서 발생
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	
	/**
	 * 배경음을 플레이하기에 적당하다능..
	 * 
	 * @author hansoo
	 */
	public class BGSound extends EventDispatcher
	{
		
		private var currentVolume:Number = 1.0;
		private var bgsound:Sound;
		private var ch:SoundChannel;		
		private var volumeTimer:Timer;
		private var tgVol:Number;
		private var volStep:Number = 0.05;

		/**
		 * 소리파일 경로 
		 */
		public var mp3FileUrl:String;
		/**
		 * 반복 재생할 건지 여부 
		 */
		public var isLoop:Boolean;
		
		private var mPlaying:Boolean = false;
		/**
		 * 재생중인지
		 * @return 
		 * 
		 */
		public function get isPlaying():Boolean {
			if(bgsound == null || ch == null) {
				return false;
			}
			else {
				return mPlaying;
			}
		}
		
		
		/**
		 *플레이 해드 위치 milliseconds 
		 */
		public function get position():Number {
			if(ch == null || bgsound == null) return 0;
			return ch.position;
		}
		
		/**
		 * @param mp3FileUrl mp3파일 경로
		 */
		public function BGSound(mp3FileUrl:String = null, isLoop:Boolean = true)
		{			
			this.mp3FileUrl = mp3FileUrl;
			this.isLoop = isLoop;
			
			volumeTimer = new Timer(50);
			volumeTimer.addEventListener(TimerEvent.TIMER, onTimer);
			
		}

		/**
		 * 정지
		 */
		public function off():void{
			if(ch != null ) ch.stop();
			ch = null;
			bgsound = null;
			if(volumeTimer != null) volumeTimer.stop();
			mPlaying = false;
		}

		/**
		 * 재생 시작
		 * @param initVolume
		 */
		public function on(initVolume:Number = 1.0):void{

			currentVolume = initVolume;
			
			var req:URLRequest = new URLRequest(this.mp3FileUrl);
			if(bgsound == null)
			{
				bgsound = new Sound();
				bgsound.addEventListener(IOErrorEvent.IO_ERROR, sndIoErr);
				bgsound.load(req);
				bgsound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
			}
			else {
				onSoundLoadComplete();
			}
			
		}
		
		private function onSoundLoadComplete(e:Event = null):void {
			ch = bgsound.play();
			ch.addEventListener(Event.SOUND_COMPLETE, sndComplete);
			
			var trans:SoundTransform = new SoundTransform(currentVolume, 0.0);
			ch.soundTransform = trans;
			mPlaying = true;
		}

		/**
		 * 볼륨을 바로 지정
		 * @param value 0.0~1.0
		 */
		public function setVolume(value:Number):void
		{
			var trans:SoundTransform = new SoundTransform(value, 0.0);
			ch.soundTransform = trans;
		}
		/**
		 * 볼륨을 죽인다.
		 */
		public function volumeDown():void{
			volStep = -0.05;
			tgVol = 0;
			volumeTimer.stop();
			volumeTimer.reset();
			volumeTimer.start();

		}

		/**
		 * 볼륨을 서서히  변경
		 * @param value 0.0~1.0
		 */
		public function volumeTo(value:Number):void{
			tgVol = value;
			volumeTimer.stop();
			volumeTimer.reset();
			volumeTimer.start(); 
		}

		/**
		 * 볼륨을 최대로 올린다.
		 */
		public function volumeUp():void{
			volStep = 0.05;
			tgVol = 1.0;
			volumeTimer.stop();
			volumeTimer.reset();
			volumeTimer.start(); 
		}

		private function onTimer(e:TimerEvent):void{
			currentVolume += (tgVol - currentVolume) *0.1;
			if(Math.abs(currentVolume - tgVol) < 0.1){
				currentVolume = tgVol;
				volumeTimer.stop();
			}
			setVolume(currentVolume);
		}

		private function sndComplete(e:Event):void{
			ch.stop();
			
			if(isLoop){
				ch = bgsound.play();
				ch.addEventListener(Event.SOUND_COMPLETE, sndComplete);
				setVolume(currentVolume);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function sndIoErr(e:IOErrorEvent):void
		{
			trace("bgm io err");
			dispatchEvent(new IOErrorEvent(e.type, e.bubbles, e.cancelable, e.text));
		}
	}
}

