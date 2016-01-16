package hansune.mask
{
	import flash.display.Sprite;

	public class BezierHandle extends Sprite
	{
		public function BezierHandle(initX:Number =0, initY:Number=0, color:uint = 0xaaaaff, size:uint = 16)
		{

			this.x = initX;
			this.y = initY;

			this.graphics.beginFill(color);
			this.graphics.drawRect(-size/2,-size/2,size,size);
			this.graphics.endFill();

			this.graphics.lineStyle(1,0);
			this.graphics.moveTo(0,-(size/2));
			this.graphics.lineTo(0,(size/2));
			this.graphics.moveTo(-(size/2),0);
			this.graphics.lineTo((size/2),0);

		}

	}
}

