//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

package hansune.mask
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * BezierCircle
	 * @author hansoo
	 */
	public class BezierCircle extends AbsBezierMask
	{

		/**
		 * BezierCircle constructor
		 */
		public function BezierCircle()
		{
			defaultInfo = new BezierCircleInfo();
			defaultInfo.position[0] = new Point(0,0);
			defaultInfo.position[1] = new Point(200,0);
			defaultInfo.position[2] = new Point(200,200);
			defaultInfo.position[3] = new Point(0,200);
			defaultInfo.position[4] = new Point(100,0);
			defaultInfo.position[5] = new Point(200,100);
			defaultInfo.position[6] = new Point(100,200);
			defaultInfo.position[7] = new Point(0,100);
			
			_info = new BezierCircleInfo();
			handles = new Vector.<BezierHandle>(8);

			handles[0] = new BezierHandle();
			handles[1] = new BezierHandle();
			handles[2] = new BezierHandle();
			handles[3] = new BezierHandle();

			handles[4] = new BezierHandle((handles[0].x+handles[1].x)/2, (handles[0].y + handles[1].y)/2, 0x00ff00);
			handles[5] = new BezierHandle((handles[1].x+handles[2].x)/2, (handles[1].y + handles[2].y)/2, 0x00ff00);
			handles[6] = new BezierHandle((handles[2].x+handles[3].x)/2, (handles[2].y + handles[3].y)/2, 0x00ff00);
			handles[7] = new BezierHandle((handles[3].x+handles[0].x)/2, (handles[3].y + handles[0].y)/2, 0x00ff00);

			super();
			
			_update();

		}

		/**
		 * bottom handler
		 * @return 
		 */
		public function get anchorB():BezierHandle{return handles[6];}
		/**
		 * bottom handler
		 * @param value
		 */
		public function set anchorB(value:BezierHandle):void{handles[6] = value;}
		/**
		 * left handler
		 * @return 
		 */
		public function get anchorL():BezierHandle{return handles[7];}
		/**
		 * left handler
		 * @param value
		 */
		public function set anchorL(value:BezierHandle):void{handles[7] = value;}
		/**
		 * right handler
		 * @return 
		 */
		public function get anchorR():BezierHandle{return handles[5];}
		/**
		 * right handler
		 * @param value
		 */
		public function set anchorR(value:BezierHandle):void{handles[5] = value;}
		/**
		 * top handler
		 * @return 
		 */
		public function get anchorT():BezierHandle{return handles[4];}
		/**
		 * top handler
		 * @param value
		 */
		public function set anchorT(value:BezierHandle):void{handles[4] = value;}
		
		//라인 업데이트 
		override protected function _lineUpdate():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x00ff00);
			this.graphics.moveTo(handles[0].x, handles[0].y);
			this.graphics.lineTo(handles[1].x, handles[1].y);
			this.graphics.lineTo(handles[2].x, handles[2].y);
			this.graphics.lineTo(handles[3].x, handles[3].y);
			this.graphics.lineTo(handles[0].x, handles[0].y);
			
			this.graphics.lineStyle(1,0x00ff00);
			this.graphics.moveTo(handles[4].x, handles[4].y);
			this.graphics.lineTo(handles[5].x, handles[5].y);
			this.graphics.lineTo(handles[6].x, handles[6].y);
			this.graphics.lineTo(handles[7].x, handles[7].y);
			this.graphics.lineTo(handles[4].x, handles[4].y);
		}

		

		override internal function _update():void
		{
			if(contains(handles[0]))
			{
				_shape.graphics.clear();
				_shape.graphics.beginFill(_color, 0.3);
				_shape.graphics.moveTo(handles[4].x, handles[4].y);
				_shape.graphics.curveTo(handles[1].x, handles[1].y, handles[5].x, handles[5].y);
				_shape.graphics.curveTo(handles[2].x, handles[2].y, handles[6].x, handles[6].y);
				_shape.graphics.curveTo(handles[3].x, handles[3].y, handles[7].x, handles[7].y);
				_shape.graphics.curveTo(handles[0].x, handles[0].y, handles[4].x, handles[4].y);
				_shape.graphics.endFill();

				_lineUpdate();
			}
			else {
				this.graphics.clear();
				_shape.graphics.clear();
				_shape.graphics.beginFill(0x000000, 1.0);
				_shape.graphics.moveTo(handles[4].x, handles[4].y);
				_shape.graphics.curveTo(handles[1].x, handles[1].y, handles[5].x, handles[5].y);
				_shape.graphics.curveTo(handles[2].x, handles[2].y, handles[6].x, handles[6].y);
				_shape.graphics.curveTo(handles[3].x, handles[3].y, handles[7].x, handles[7].y);
				_shape.graphics.curveTo(handles[0].x, handles[0].y, handles[4].x, handles[4].y);
				_shape.graphics.endFill();
			}
		}

		override internal function fitToRect():void{

			handles[4].x = (handles[0].x + handles[1].x)/2;
			handles[4].y = (handles[0].y + handles[1].y)/2;

			handles[5].x = (handles[1].x + handles[2].x)/2;
			handles[5].y = (handles[1].y + handles[2].y)/2;

			handles[6].x = (handles[2].x + handles[3].x)/2;
			handles[6].y = (handles[2].y + handles[3].y)/2;

			handles[7].x = (handles[3].x + handles[0].x)/2;
			handles[7].y = (handles[3].y + handles[0].y)/2;

			_update();
		}
		
		
	}
}

