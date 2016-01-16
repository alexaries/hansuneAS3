package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import hansune.media.SimpleVideo;
	import hansune.ui.TestButton;
	

	[SWF(width="800", height="500")]
	public class simpleVideo_example extends Sprite
	{
		private var sim:SimpleVideo;
		private var tf:TextField;
		public function simpleVideo_example()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			sim = new SimpleVideo(640, 360);
			sim.fileUrl = "../data/movie.mp4";
			sim.debug = true;
			sim.loop = false;
			sim.play();
			sim.addEventListener(Event.CHANGE, onTime);
			sim.addEventListener(Event.OPEN, onStart);
			sim.addEventListener(Event.COMPLETE, onEndVideo);
			sim.addEventListener("closing", onBeforEndVideo);
			sim.y = 0;
			sim.x = 0;
			addChild(sim);
			
			var bt:TestButton = new TestButton("play");
			addChild(bt);
			bt.x = 700;
			bt.y = 0;
			bt.addEventListener(MouseEvent.CLICK, onplayClick);
			
			bt = new TestButton("close");
			bt.x = 700;
			bt.y = 30;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onstopClick);
			
			bt = new TestButton("pause");
			bt.x = 700;
			bt.y = 60;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onpauseClick);
			
			bt = new TestButton("resume");
			bt.x = 700;
			bt.y = 90;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onresumeClick);
			
			bt = new TestButton("+");
			bt.x = 700;
			bt.y = 120;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onVu);
			
			bt = new TestButton("-");
			bt.x = 730;
			bt.y = 120;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onVd);
			
			bt = new TestButton("seek+3");
			bt.x = 700;
			bt.y = 150;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onseek);
			
			bt = new TestButton("seek-3");
			bt.x = 700;
			bt.y = 180;
			addChild(bt);
			bt.addEventListener(MouseEvent.CLICK, onseek2);
			
			
			tf = new TextField();
			tf.width = 800;
			tf.height = 300;
			tf.mouseEnabled = false;
			tf.defaultTextFormat = new TextFormat(null, null, 0xffffff);
			addChild(tf);
			
		}
		
		private function onseek(event:MouseEvent):void
		{
			sim.seek(sim.time + 3);
		}
		
		private function onseek2(event:MouseEvent):void
		{
			sim.seek(sim.time - 3);
		}
		
		private function onresumeClick(event:MouseEvent):void
		{
			sim.resume();
		}
		
		private function onpauseClick(event:MouseEvent):void
		{
			sim.pause();
		}
		
		private function onVd(event:MouseEvent):void
		{
			sim.volume = Math.max(0, sim.volume - 0.1);
		}
		
		private function onVu(event:MouseEvent):void
		{
			sim.volume = Math.min(1, sim.volume + 0.1);
		}
		
		protected function onBeforEndVideo(event:Event):void
		{
			tracing("ending");
		}
		
		protected function onEndVideo(event:Event):void
		{
			tracing("ended");
		}
		
		protected function onStart(event:Event):void
		{
			tracing("start");
		}
		
		protected function onTime(event:Event):void
		{
			tracing(sim.time, sim.duration, sim.timePercent);
//			trace("-", player.time, player.duration);
//			tracing("==");
		}
		
		private function onplayClick(e:MouseEvent):void {
			
			sim.play();
		}
		private function onstopClick(e:MouseEvent):void {
			sim.close();
		}
		
		private function tracing(... arg):void {
			tf.appendText(arg.join("\t") + "\n");
			tf.scrollV = tf.numLines;
			if(tf.numLines > 100) {
				tf.text = "";
			}
		}
	}
}