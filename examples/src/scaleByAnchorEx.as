package
{
	import hansune.utils.scaleByAnchor;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class scaleByAnchorEx extends Sprite
	{
		
		private var rect:SimpleShape;
		private var spot:SimpleShape;
		private var pointAtDown:Point = new Point();
		private var isDown:Boolean = false;
		private var current:Number;
		
		public function scaleByAnchorEx()
		{
			super();
			
			spot = new SimpleShape(0xff0000,1,2,2);			
			
			rect = new SimpleShape(0xffff00,1,100,100);
			rect.x = 100;
			rect.y = 100;
			
			var container:Sprite = new Sprite();
			container.addChild(rect);
			container.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			container.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			container.addEventListener(MouseEvent.MOUSE_UP, onUp);
			addChild(container);
			addChild(spot);
			
			
		}
		
		private function onDown(e:MouseEvent):void{
			pointAtDown.x = mouseX;
			pointAtDown.y = mouseY;
			current = rect.scaleX;
			spot.x = mouseX;
			spot.y = mouseY;
			isDown = true;
		}
		
		private function onMove(e:MouseEvent):void{
			if(isDown){
				var scaleBy:Number = (pointAtDown.y - mouseY) / 100 + current;
				scaleByAnchor(rect, pointAtDown, scaleBy, scaleBy);
			}
		}
		
		private function onUp(e:MouseEvent):void{
			isDown = false;
		}
		
	}
}


import flash.display.Sprite;

class SimpleShape extends Sprite {
	public function SimpleShape(color:uint, alpha:Number, w:Number, h:Number){
		graphics.beginFill(color,alpha);
		graphics.drawRect(0,0,w,h);
		graphics.endFill();
	}
}