package hansune.display
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import hansune.display.IDefaultPosition;
	import hansune.display.ImageSlider;
	import hansune.geom.Position;
	import hansune.utils.Log;
	
	public class ImageAutoSlider extends ImageSlider implements IDefaultPosition
	{
		 override public function get className():String {
			return "ImageAutoSlider";
		}
		private var paths:Vector.<String>;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var timer:Timer;
		
		public function ImageAutoSlider(interval:int = 5)
		{
			super(1080, 650);
			
			paths = new Vector.<String>();
			
			onTimer(null);
			
			timer = new Timer(interval * 1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
		}
		
		private function onRemoveStage(event:Event):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
			Log.d(className, "onRemoveStage");
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if(paths == null || paths.length < 2) return;			
			if(timer == null) left(paths[0]);
			else left(paths[timer.currentCount % paths.length]);
		}
		
		public function pause():void {
			if(timer != null) timer.stop();
		}
		
		public function resume():void {
			if(timer != null) timer.start();
		}
		
		// IDefaultPosition 구현
		
		public function setDefaultPosition(x:Number, y:Number):void {
			dx = x;
			dy = y;
		}
		
		public function get defaultPosition():Position {
			return new Position(dx, dy);
		}
		
		public function gotoDefault():void {
			this.x = dx;
			this.y = dy;
		}
		
		public function addPaths(folder:String, fileNames:Vector.<String>):void
		{
			for each(var p:String in fileNames) {
				paths.push(folder + p);
			}
			if(paths.length > 0) just(paths[0]);
		}
	}
}
