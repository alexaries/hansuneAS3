package
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import hansune.ui.ScrollBar;
	import hansune.ui.ScrollBarStyle;

	[SWF(width='800', height='600', backgroundColor='#000000', frameRate='60')]
	public class scrollBar_ex extends Sprite
	{
		private var shape:Shape;
		private var scrollbar:ScrollBar;
		private var viewRect:Rectangle;
		public function scrollBar_ex()
		{
			shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.LINEAR,[0xfff000,0x00ff00],[1,1],[0,255]);
			shape.graphics.drawRect(0,0,400,1000);
			shape.graphics.endFill();
			shape.x = 100;
			shape.y = 100;
			addChild(shape);
			
			viewRect = new Rectangle(0,0,400,300);
			scrollbar = new ScrollBar(viewRect.height, shape.height, ScrollBarStyle.VERTICAL);
			scrollbar.x = shape.x + viewRect.right + 5;//_scrollbarV width : 5
			scrollbar.y = shape.y + viewRect.y;
			scrollbar.start();
			addChild(scrollbar);
			
			scrollbar.addEventListener(Event.CHANGE, onChange);
			
			
		}
		
		private function onChange(e:Event):void {
			shape.y = 100 + (viewRect.height - shape.height) * scrollbar.position;
		}
	}
}