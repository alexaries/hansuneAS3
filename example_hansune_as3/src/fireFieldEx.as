package
{
	import hansune.effects.FireField;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[swf(width='400',height='400',  backgroundColor='#000000', frameRate='60')]
	public class fireFieldEx extends Sprite
	{
		private var ff:FireField;
		public function fireFieldEx()
		{
			super();
			ff = new FireField(400,400);
			ff.fireSpeed = 4;
			addChild(ff);
			
			var a:Sprite = new Sprite();
			a.graphics.beginFill(0xffff0f);
			a.graphics.drawCircle(200,300,50);
			a.graphics.endFill();
			
			ff.addObject(a);
			
			a.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			a.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onDown(e:MouseEvent):void{
			(e.currentTarget as Sprite).startDrag();
		}
		private function onUp(e:MouseEvent):void{
			(e.currentTarget as Sprite).stopDrag();
		}
		
	}
}