package hansune.media
{
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * build 가 완료되었을 때 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 각종 에러 
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 *SuperSound 는 BGSound 와 EffectSound 를 통합하여 쓰기 편하게 만듦. 
	 * @author hansoo
	 * 
	 */
	public class SuperSound extends EventDispatcher {
		
		private static var ins:SuperSound;
		
		private static var instance:SuperSound;
		
		private var effectSound:EffectSound;
		private var bgmSound:Vector.<BGSound>;
		private var bgmItems:Vector.<SuperSoundItem>;
		private var effectItems:Vector.<SuperSoundItem>;
			
		public function SuperSound(tt:TT)
		{
			super();
			bgmItems = new Vector.<SuperSoundItem>();
			effectItems = new Vector.<SuperSoundItem>();
			bgmSound = new Vector.<BGSound>();
			effectSound = new EffectSound();
		}
		
		private static function buildInstance():void {
			if(instance == null) 
			{
				instance = new SuperSound(new TT());
			}
		}
		
		/**
		 * 배경 음악 파일을 Que에 등록한다. 
		 * @param bgm
		 * @return 
		 * 
		 */
		public static function addBGMQue(bgm:SuperSoundItem):uint {
			buildInstance();
			return instance.bgmItems.push(bgm);
		}
		
		/**
		 *  효과 음악 파일을 Que에 등록한다. 
		 * @param effect
		 * @return 
		 * 
		 */
		public static function addEffectQue(effect:SuperSoundItem):uint {
			buildInstance();
			return instance.effectItems.push(effect);
		}
		
		/**
		 *  Que 등록되어 있는  SuperSoundItem 들을 로드한다.<br/>
		 *  build 를 실행해야 사용할 수 있다.
		 * @return 
		 * 
		 */
		public static function build():SuperSound {
			buildInstance();
			instance.build();
			return instance;
		}
		
		
		/**
		 * 등록된 데이터를 해제한다. 
		 * @return 
		 * 
		 */
		public static function release():SuperSound {
			if(instance == null) return null;
			instance.release();
			return instance;
		}
		
		
		/**
		 *  SuperSound 내부 객체에 addEventListener 한다.
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 *  SuperSound 내부 객체에 removeEventListener 한다.
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			instance.removeEventListener(type, listener, useCapture);
		}
		
		private function build():void {
			
			var i:int = 0;
			for(i=0; i<bgmItems.length; i++){
				bgmSound.push(new BGSound(bgmItems[i].sourceUrl, bgmItems[i].isLoop));
			}
			
			for(i=0; i<effectItems.length; i++){
				effectSound.addQue(effectItems[i].sourceUrl, effectItems[i].name);
			}
			
			effectSound.addEventListener(Event.COMPLETE, onLoad);
			effectSound.addEventListener(ErrorEvent.ERROR, onError);
			effectSound.runQue();
			
			if(effectItems.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			trace("build");
		}
		
		private function onLoad(e:Event):void {
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onError(e:ErrorEvent):void {
			dispatchEvent(new ErrorEvent(e.type, e.bubbles, e.cancelable, "can't load effect sound file"));
		}
		
		private function release():void {
			var i:int = 0;
			var ll:int = bgmItems.length;
			for(i=0; i<ll; i++){
				bgmSound[i].off();
			}
			for(i=0; i<ll; i++){
				bgmSound.pop();
			}
			
			effectSound.dispose();
			
		}
		
		
		
		/**
		 * 이펙트 효과음 플레이
		 * @param name
		 * 
		 */
		public static function effect(name:String):EffectSound {
			
			if(instance == null) {
				throw new IllegalOperationError("build 명령어를 먼저 수행해야 합니다.");
			}
			
			instance.effectSound.name = name;
			return instance.effectSound;
		}
		
		/**
		 * 백그라운 음악 
		 * @param name
		 * @return BGSound
		 * 
		 */
		public static function bgm(name:String):BGSound {
			
			var bgmSound:BGSound = null;
			
			for(var i:int=0; i< instance.bgmItems.length; i++){
				if(instance.bgmItems[i].name == name){
					bgmSound = instance.bgmSound[i];
					break;
				}
			}
			return bgmSound;
		}
	}
}

internal class TT { 
	public function TT(){}
}
