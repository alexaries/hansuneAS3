package hansune.mask
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;

	public class BezierCircleInfo extends AbsBezierInfo
	{
		public function BezierCircleInfo()
		{
			style = BezierMaskStyle.CIRCLE;
			positionNums = 8;
			position = new Vector.<Point>(positionNums);

			for (var i:int = 0; i<positionNums; ++i)
			{
				position[i] = new Point();
			}
		}

		override public function clone():AbsBezierInfo
		{
			var info:BezierCircleInfo = new BezierCircleInfo();
			for (var i:int = 0; i<positionNums; ++i)
			{
				info.position[i] = this.position[i].clone();
			}
			info.x = this.x;
			info.y = this.y;

			return info;
		}
	}
}

