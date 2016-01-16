package hansune.media
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 사운드 로드 완료시
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * 사운드 로드 오류시 
	 */	
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 *  EffectSound
	 * 유의사항:너무 많은 소리파일은 메모리의 영향을 받으니 주의를 요함.
	 * @author hansoo
	 * 
	 */
	public class EffectSound extends EventDispatcher
	{
		private var sounds:Dictionary;
		private var qued:Array;
		private var loadedCount:int;
		private var channel:SoundChannel;
		
		/**
		 * 현재 플레이하는 이름 
		 */
		public var name:String = "";
		
		/**
		 *  EffectSound 생성자
		 * 
		 */
		public function EffectSound() 
		{
			channel = new SoundChannel();
			sounds = new Dictionary();
			qued = new Array();
		}
		
		/**
		 * 로드할 파일 등록 
		 * @param urlToFile
		 * @param callname
		 * 
		 */
		public function addQue(urlToFile:String, callname:String):void {
			qued.push({url:urlToFile, name:callname});
		}
		
		/**
		 * 기다리는 파일 로드 
		 * 
		 */
		public function runQue():void {
			loadedCount = 0;
			if (qued.length) loadfile(0);
		}
		
		/**
		 * name 의 소리파일 재생 
		 * @param name
		 * 
		 */
		public function play(name:String = null):void {
			
			if(this.name == null){
				if(name == null || name.length < 1){
					return;
				} else {
					this.name = name;
				}
			}
			
			for(var i:int=0;i<qued.length;++i){
				if (this.name == qued[i].name) {
					channel = sounds[this.name].play();
					break;
				}
			}
		}
		
		/**
		 * 무음 설정 
		 * 
		 */
		public function mute():void {
			var transform:SoundTransform = new SoundTransform(0, 0);
			channel.soundTransform = transform;
		}
		
		/**
		 * 무음해제 
		 * 
		 */
		public function unmute():void {
			var transform:SoundTransform = new SoundTransform(1, 0);
			channel.soundTransform = transform;
		}
		
		/**
		 * 소리파일 레퍼런스 해제 
		 * 
		 */
		public function dispose():void {
			qued.forEach(deleteDictionayItem);
			qued = [];
			sounds = new Dictionary();
		}		
		
		private function deleteDictionayItem(element:*, index:int, arr:Array):void {
			try {
				Sound(sounds[element.name]).close();
			} catch (e:*) {
				//
			}
			delete sounds[element.name];
		}
		
		private function loadfile(n:int):void {
			loadedCount = n;
			var req:URLRequest = new URLRequest(qued[n].url);
			var snd:Sound = new Sound();
			snd.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			snd.addEventListener(Event.COMPLETE, completeHandler);
			snd.load(req);
		}
		
		private function errorHandler(e:IOErrorEvent):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.toString()));
		}
		
		private function completeHandler(e:Event):void {
			if (e.target is Sound) {
				sounds[qued[loadedCount].name] = Sound(e.target);
			}
			
			if (loadedCount+1 < qued.length) {
				loadfile(loadedCount+1);
			} else {
				dispatchEvent(new Event(Event.COMPLETE, false, false));
			}
		}
	}
}