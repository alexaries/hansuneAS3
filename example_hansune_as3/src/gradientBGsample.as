package {
	
	import hansune.display.GradientBg;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="400",height="400",backgroundColor="#000000",frameRate="50")]
	
	public class gradientBGsample extends Sprite {
		
		private var bg:GradientBg;
		
		public function gradientBGsample() {
			
			bg = new GradientBg(0,0,0,0,0,400,0,400,
								0,0,400,0,400,400,0,400);
			
			
			bg.setGradient(GradientType.LINEAR,'0xffff00','0x0000ff',1,1);
			bg.addEventListener(GradientBg.COMPLETE, bgDrawEnd);
			bg.speed = 0.1;
			bg.draw();
			
			addChild(bg);
		}
		
		private function bgDrawEnd(e:Event):void {
			trace("draw complt");
		}
	}
}