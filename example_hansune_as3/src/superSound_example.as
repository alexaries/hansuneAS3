package
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import hansune.media.SuperSound;
	import hansune.media.SuperSoundItem;

	public class superSound_example extends Sprite
	{		
		public function superSound_example() 
		{
			SuperSound.addEffectQue(new SuperSoundItem("../data/cancel.mp3", "cancel"));
			SuperSound.addEffectQue(new SuperSoundItem("../data/focus.mp3", "focus"));
			SuperSound.addEffectQue(new SuperSoundItem("../data/focus.mp3", "click"));
			
			SuperSound.addBGMQue(new SuperSoundItem("../data/wallBgm.mp3", "bgm", false));
			
			SuperSound.addEventListener(Event.COMPLETE, soundOk);
			SuperSound.addEventListener(ErrorEvent.ERROR, err);
			SuperSound.build();
		}
		
		private function soundOk(e:Event):void {
			trace("ok");
			SuperSound.effect("focus");
			SuperSound.bgm("bgm").on(0);
			SuperSound.bgm("bgm").volumeUp();
		}
		
		private function err(e:ErrorEvent):void {
			trace(e.text);
		}
	}
}