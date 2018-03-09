package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import hansune.gl.HBitmap;
	import hansune.gl.Vector3DArray;
	
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]

	public class gl_bsplineTest2 extends Sprite
	{
		private var glb:HBitmap;
		private var spot:Vector3DArray;
		private var filter:BlurFilter;
		private var filter1:ColorMatrixFilter;
		private var boneLength:uint = 50;
		private var spotN:uint = 10;
		
		public function gl_bsplineTest2()
		{
			super();
			
			filter = new BlurFilter(3, 3, 3);
			
			var matrix:Array = new Array();
			matrix = matrix.concat([0.99, 0, 0.01, 0, 0]);// red
			matrix = matrix.concat([0.01, 0.99, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0.01, 0.98, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 0.88, 0]);// alpha
			filter1 = new ColorMatrixFilter(matrix);
			
			spot = new Vector3DArray(spotN);
			spotDistance = new Array(spotN);
			for(var i:int=0; i<spotN; ++i){
				spotDistance[i] = boneLength;
			}
			
			glb = new HBitmap(1024,768);
			glb.lineColor = 0xffff00;
			glb.resolution = 20;
			glb.anti_aliasing = true;
			this.addChild(glb);
			
			this.addEventListener(Event.ENTER_FRAME, onRender);
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onMove(e:MouseEvent):void {
			//spotDistance[0] += 10;
		}
		
		private var tempAngle:Number;
		private var spotDistance:Array;
		private function onRender(e:Event):void
		{
			spot[0].x = mouseX;
			spot[0].y = mouseY;
			//spotDistance[0] *= 0.9;
			
			for(var i:uint=0; i< spotN - 1; i++){
				spotDistance[i+1] += (spotDistance[i] - spotDistance[i+1]) * 0.1;
				
				tempAngle = Math.atan2(spot[i+1].y - spot[i].y, spot[i+1].x - spot[i].x);
				spot[i + 1].x = spot[i].x + spotDistance[i] * Math.cos(tempAngle);
				spot[i + 1].y = spot[i].y + spotDistance[i] * Math.sin(tempAngle);
				
			}
			glb.bSpline(spot, 0.5, false);
			
			//glb.bitmapData.applyFilter(glb.bitmapData, new Rectangle(0,0,glb.width, glb.height), new Point(), filter);
			glb.bitmapData.applyFilter(glb.bitmapData, new Rectangle(0,0,glb.width, glb.height), new Point(), filter1);

		}
		
	}
}