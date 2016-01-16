package  
{
	
	/**
	 * ...
	 * @author hansoo
	 */
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import hansune.media.EffectSound;

	public class soundCollectionTest extends Sprite
	{
		private var soundCollection:EffectSound;
		
		public function soundCollectionTest() 
		{
			soundCollection = new EffectSound();
			soundCollection.addQue("../data/cancel.mp3", "cancel");
			soundCollection.addQue("../data/focus.mp3", "focus");
			soundCollection.addQue("../data/focus.mp3", "click");
			soundCollection.addEventListener(Event.COMPLETE, soundOk);
			soundCollection.addEventListener(ErrorEvent.ERROR, err);
			soundCollection.runQue();
		}
		
		private function soundOk(e:Event):void {
			soundCollection.play("focus");
			//soundCollection.dispose();
		}
		
		private function err(e:ErrorEvent):void {
			trace(e.text);
		}
		
	}
	
}