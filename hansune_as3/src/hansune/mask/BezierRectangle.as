package hansune.mask
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * BezierRectangle
	 * @author hansoo
	 */
	public class BezierRectangle extends AbsBezierMask
	{
		/**
		 * BezierRectangle constructor
		 */
		public function BezierRectangle()
		{
			defaultInfo = new BezierRectangleInfo();
			defaultInfo.position[0] = new Point(0,0);
			defaultInfo.position[1] = new Point(200,0);
			defaultInfo.position[2] = new Point(200,200);
			defaultInfo.position[3] = new Point(0,200);
			defaultInfo.round = 0;
			
			_info = new BezierRectangleInfo();
			handles = new Vector.<BezierHandle>(4);
			handles[0] = new BezierHandle();
			handles[1] = new BezierHandle();
			handles[2] = new BezierHandle();
			handles[3] = new BezierHandle();

			super();
			
			_update();

		}
		
		override internal function _update():void
		{
			
			if(round == 0){
				_update2();
				return;
			}
			
			var controlX:Number;
			var controlY:Number;
			var anchorX:Number;
			var anchorY:Number;
			var rad:Number;
		
			_shape.graphics.clear();
			_shape.graphics.beginFill(_color, 0.3);
			
			//left top
			rad = Math.atan2(handles[3].y - handles[0].y, handles[3].x - handles[0].x);
			anchorX = Math.cos(rad) * round + handles[0].x;
			anchorY = Math.sin(rad) * round + handles[0].y;
			_shape.graphics.moveTo(anchorX, anchorY);
			
			rad = Math.atan2(handles[1].y - handles[0].y, handles[1].x - handles[0].x);
			controlX = handles[0].x;
			controlY = handles[0].y;
			anchorX = Math.cos(rad) * round + handles[0].x;
			anchorY = Math.sin(rad) * round + handles[0].y;
			_shape.graphics.curveTo(controlX, controlY, anchorX, anchorY);
			
			//right top
			anchorX = -Math.cos(rad) * round + handles[1].x;
			anchorY = -Math.sin(rad) * round + handles[1].y;
			_shape.graphics.lineTo(anchorX, anchorY);
			
			
			rad = Math.atan2(handles[2].y - handles[1].y, handles[2].x - handles[1].x);
			controlX = handles[1].x;
			controlY = handles[1].y;
			anchorX = Math.cos(rad) * round + handles[1].x;
			anchorY = Math.sin(rad) * round + handles[1].y;
			_shape.graphics.curveTo(controlX, controlY, anchorX, anchorY);
			
			//right bottom
			anchorX = -Math.cos(rad) * round + handles[2].x;
			anchorY = -Math.sin(rad) * round + handles[2].y;
			_shape.graphics.lineTo(anchorX, anchorY);

			
			rad = Math.atan2(handles[3].y - handles[2].y, handles[3].x - handles[2].x);
			controlX = handles[2].x;
			controlY = handles[2].y;
			anchorX = Math.cos(rad) * round + handles[2].x;
			anchorY = Math.sin(rad) * round + handles[2].y;
			_shape.graphics.curveTo(controlX, controlY, anchorX, anchorY);
			
			//left bottom
			anchorX = -Math.cos(rad) * round + handles[3].x;
			anchorY = -Math.sin(rad) * round + handles[3].y;
			_shape.graphics.lineTo(anchorX, anchorY);

			
			rad = Math.atan2(handles[0].y - handles[3].y, handles[0].x - handles[3].x);
			controlX = handles[3].x;
			controlY = handles[3].y;
			anchorX = Math.cos(rad) * round + handles[3].x;
			anchorY = Math.sin(rad) * round + handles[3].y;
			_shape.graphics.curveTo(controlX, controlY, anchorX, anchorY);
			
			
			rad = Math.atan2(handles[3].y - handles[0].y, handles[3].x - handles[0].x);
			anchorX = Math.cos(rad) * round + handles[0].x;
			anchorY = Math.sin(rad) * round + handles[0].y;
			_shape.graphics.lineTo(anchorX, anchorY);
			_shape.graphics.endFill();
			
			_lineUpdate();
		}
		

		
		override internal function fitToRect():void{
			_update();
		}
		
		private function _update2():void
		{
			_shape.graphics.clear();
			_shape.graphics.beginFill(_color,0.3);
			_shape.graphics.moveTo(handles[0].x, handles[0].y);
			_shape.graphics.lineTo(handles[1].x, handles[1].y);
			_shape.graphics.lineTo(handles[2].x, handles[2].y);
			_shape.graphics.lineTo(handles[3].x, handles[3].y);
			_shape.graphics.lineTo(handles[0].x, handles[0].y);
			
			_lineUpdate();
		}
	}
}

