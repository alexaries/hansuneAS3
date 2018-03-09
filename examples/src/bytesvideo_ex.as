package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import hansune.media.BytesVideo;
	import hansune.ui.TestButton;
	
	import net.hires.debug.Stats;
	
	public class bytesvideo_ex extends Sprite
	{
		
		private var xml:XML = <data><name id="1">abc</name> <name id="2">def</name></data>;
		private var player:BytesVideo;
		public function bytesvideo_ex()
		{
			player = new BytesVideo();
			//player.fileUrl = "../data/test.flv";
			//player.loadFile("C:/Users/Administrator/Desktop/egg/skHD/HD/HD_01/HD_01_SSP-02.f4v");
			player.loadFile("data/sample.flv");
			player.isLoop = true;
			player.addEventListener(Event.ADDED, onLoad);
			
			trace(xml.hasOwnProperty("name"));
			trace(String(xml.name[0]).length);
			trace(xml.name[0].@id);
			trace(xml.name[0].hasOwnProperty("@id"));
		}
		
		
		
		private function onLoad(e:Event):void {
			
			addChild(player);
			
			var bt:TestButton = new TestButton("play");
			addChild(bt);
			bt.x = 100;
			bt.addEventListener(MouseEvent.CLICK, onplayClick);
			
			bt = new TestButton("pause");
			bt.x = 200;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onstopClick);
			
			addChild(new Stats());
		}
		
		private function onplayClick(e:MouseEvent):void {
			
			player.play();
		}
		private function onstopClick(e:MouseEvent):void {
			player.pause();
		}
	}
}