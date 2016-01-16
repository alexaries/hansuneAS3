package hansune.mask
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;

	public class BezierRectangleInfo extends AbsBezierInfo
	{
		
		public function BezierRectangleInfo()
		{
			style = BezierMaskStyle.RECTANGLE;
			positionNums = 4;
			position = new Vector.<Point>(positionNums);

			for (var i:int = 0; i<positionNums; ++i)
			{
				position[i] = new Point();
			}
		}

		override public function clone():AbsBezierInfo
		{
			var info:BezierRectangleInfo = new BezierRectangleInfo();
			for (var i:int = 0; i<positionNums; ++i)
			{
				info.position[i] = this.position[i].clone();
			}
			
			info.round = this.round;
			info.x = this.x;
			info.y = this.y;
			
			return info;
		}
	}
}

