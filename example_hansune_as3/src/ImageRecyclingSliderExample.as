package
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import hansune.sets.ImageRecyclingSlider;

	[SWF(width="600", height="400")]
	public class ImageRecyclingSliderExample extends Sprite
	{
		private var slider:ImageRecyclingSlider;
		
		public function ImageRecyclingSliderExample()
		{
			
			slider = new ImageRecyclingSlider(400, 200);
			slider.itemViewRect = new Rectangle(0, 0, 100, 100);
			slider.itemSpan = 10;
			slider.addQueFile("../data/kim.jpg");
			slider.addQueFile("../data/kim.jpg");
			slider.addQueFileArray(["../data/kim2.jpg", "../data/kim.jpg", "../data/kim.jpg"]);
			slider.addEventListener(Event.COMPLETE, onCl);
			slider.addEventListener(DataEvent.DATA, onDataItem);
			slider.runQue();
			addChild(slider);
			
			slider.x = 100;
			slider.y = 100;
			
			graphics.lineStyle(1, 0xff0000);
			graphics.drawRect(100, 100, 400, 200);
			graphics.endFill();
		}
		
		protected function onDataItem(event:DataEvent):void
		{
			trace("item click id : ", event.data);
		}
		
		private function onCl(e:Event):void {
			trace("building complete");
		}
		
		
	}
}