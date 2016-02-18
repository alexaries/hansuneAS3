package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import hansune.display.BgWiper;
	[SWF(width="400",height="400",backgroundColor="#000000",frameRate="50")]
	
	public class BgWipersample extends Sprite {
		
		private var bg:BgWiper;
		
		public function BgWipersample(){
			bg = new BgWiper(400,400);
			this.addChild(bg);
			bg.addEventListener(Event.CHANGE, imgChanged);
			bg.load("../data/kim.jpg", 0.3, BgWiper.UP);
		}
		
		private function imgChanged(e:Event):void{
			trace("image changed");
		}
	}
}