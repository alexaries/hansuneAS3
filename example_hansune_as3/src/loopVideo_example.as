package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import hansune.media.LoopVideo;
	import hansune.ui.TestButton;
	
	import net.hires.debug.Stats;

	[SWF(frameRate="30", width="700", height="600")]
	
	public class loopVideo_example extends Sprite
	{
		private var player:LoopVideo;
		public function loopVideo_example()
		{
			super();
			player = new LoopVideo();
			player.fileUrl = "C:/Users/Administrator/Desktop/egg/skHC/HC/04_ICT/HC_04_ICT_SmartR_LoopBack.f4v";
			player.play();
			addChild(player);
			
			var bt:TestButton = new TestButton("play");
			addChild(bt);
			bt.x = 100;
			bt.addEventListener(MouseEvent.CLICK, onplayClick);
			
			bt = new TestButton("stop");
			bt.x = 200;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onstopClick);
			
			addChild(new Stats());
		}
		
		private function onplayClick(e:MouseEvent):void {
			
			player.play();
		}
		private function onstopClick(e:MouseEvent):void {
			player.close();
		}
	}
}