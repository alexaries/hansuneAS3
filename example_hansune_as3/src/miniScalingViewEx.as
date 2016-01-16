package
{
	import hansune.loader.BitmapLoader;
	import hansune.viewer.MiniScalingView;
	import hansune.ui.TestButton;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;


	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class miniScalingViewEx extends Sprite
	{
		private var bm:Bitmap;
		private var mc:Sprite;
		private var mini:MiniScalingView; 

		private var plusBt:TestButton;
		private var minusBt:TestButton;

		public function miniScalingViewEx()
		{
			super();
			var loader:BitmapLoader = new BitmapLoader();
			loader.addEventListener(Event.COMPLETE, _onload);
			loader.load("../data/kim2.jpg");
		}

		private function _onload(e:Event):void{
			bm = (e.target as BitmapLoader).bitmap;

			mc = new Sprite();
			addChild(mc);
			mc.addChild(bm);

			var instant:Shape = new Shape();
			instant.graphics.lineStyle(1,0x00ff00);
			instant.graphics.drawRect(0,0,bm.width, bm.height);
			instant.graphics.endFill();
			instant.alpha = 1;
			addChild(instant);

			mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
			mc.addEventListener(MouseEvent.MOUSE_MOVE, onMove);


			trace("mc.width " + mc.width + "mc.height " +mc.height);

			mini = new MiniScalingView(mc, new Rectangle(0,0,mc.width,mc.height),100,100);
			mini.init();
			mini.x = bm.width;
			addChild(mini);		

			plusBt = new TestButton("plus");
			plusBt.x = mini.x + mini.width+ 10;
			addChild(plusBt);

			minusBt = new TestButton("minus");
			minusBt.x = plusBt.x + plusBt.width;
			addChild(minusBt);

			plusBt.addEventListener(MouseEvent.CLICK, onPlus);
			minusBt.addEventListener(MouseEvent.CLICK, onMinus);
		}

		private function onPlus(e:MouseEvent):void{
			mc.scaleX += 0.1;
			mc.scaleY += 0.1;
			mini.update();
		}
		private function onMinus(e:MouseEvent):void{
			mc.scaleX -= 0.1;
			mc.scaleY -= 0.1;
			mini.update();
		}


		private var isDown:Boolean = false;
		private function onDown(e:MouseEvent):void{
			isDown = true;
			mc.startDrag();
		}

		private function onUp(e:MouseEvent):void{
			isDown = false;
			mc.stopDrag();
		}
		private function onMove(e:MouseEvent):void{
			if(isDown){
				mini.update();
			}
		}

	}
}

