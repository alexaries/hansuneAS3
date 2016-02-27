package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import hansune.motion.SooTween;
	
    [SWF(height="800", width="600")]
	public class SooTween_example extends Sprite
	{
		private var mc:Shape = new Shape();
		
		public function SooTween_example()
		{
			super();
			/*
			mc.graphics.beginFill(0xff0000);
			mc.graphics.drawRect(0,0,100,100);
			mc.graphics.endFill();
			
			addChild(mc);
			SimpleTween.debug = true;
			SimpleTween.alphaTo(mc, 0, 0.5, Cubic.easeOut, ended, "yoyo 5", {yoyo:true, repeat:2});
			SimpleTween.moveTo(mc,300,300,1,null,ended, "moveTo end");
			//
			mc = new Shape();
			mc.graphics.beginFill(0xff0000);
			mc.graphics.drawRect(0,0,100,100);
			mc.graphics.endFill();
			mc.x = 100;
			mc.y = 100;
			addChild(mc);
			
			SimpleTween.sizeTo(mc, 2, 2, 2, Cubic.easeOut, ended, "repeat:3", {repeat:3});
            */
			//
            mc = new Shape();
            mc.graphics.beginFill(0xff00ff);
            mc.graphics.drawCircle(0,0,100);
            mc.graphics.endFill();
            mc.x = 100;
            mc.y = 100;
            addChild(mc);
            
			SooTween.to(mc, 2, {x:500, scaleY:2, scaleX:2, delay:1, visible:false, onComplete:endedMax, onCompleteParams:["is", "ok"]});
		}
		
		private function ended(ss:String):void {
			trace(ss);
		}
        
        private function endedMax(a:*, b:*):void 
        {
            trace(a,b);
			trace(mc.z);
        }
              
	}
}