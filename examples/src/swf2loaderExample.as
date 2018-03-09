package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import hansune.loader.Swf2Loader;
	import hansune.ui.TestButton;

	[SWF(frameRate=24, width=800, height=600)]
	public class swf2loaderExample extends Sprite
	{
		private var loader:Swf2Loader
		private var current:String = "a";
		public function swf2loaderExample()
		{
			super();
			loader = new Swf2Loader();
			loader.addEventListener(Event.COMPLETE, onCompTransition);
			addChild(loader);
			
			loader.isSmoothAtFirst = true;
			loader.isStopAtTransition = true;
			//loader.transitionSpeed = 0.5;
			
			var nextBt:TestButton = new TestButton("load");
			addChild(nextBt);
			nextBt.addEventListener(MouseEvent.CLICK, onNext);
		}
		
		private function onNext(e:MouseEvent):void {
			if(current == "a")
			{
				loader.load("../data/sample2.swf", true);
				current = "b"
			}
			else
			{
				loader.load("../data/sample1.swf", true);
				current = "a"
			}
			
		}
		
		private function onCompTransition(e:Event):void {
			trace(loader.getContent());
			loader.getContent().play();
		}
		
	}
}