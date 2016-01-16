//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

/**
 * refer to :
 * 
 * http://helloktk.tistory.com/entry/Wus-Line-Algorithm 
 * http://freespace.virgin.net/hugo.elias/graphics/x_wuline.htm
 * http://forum.falinux.com/zbxe/?document_srl=406146
 * http://helloktk.tistory.com/entry/Circle-Drawing-Algorithm
 * 
 * Raster class - Didier Brun aka Foxy - www.foxaweb.com / http://www.bytearray.org/?p=67
 * */

package hansune.gl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import hansune.Hansune;

	/**
	 * GLBitmap class
	 * this class (extends Bitmap) has its own drawing methods for providing 
	 * some drawing methods onto BitmapData instances.
	 * 
	 * @author 	hansoo
	 * @version 0.1
	 * @date	2010-02-04
	 * @link	http://code.google.com/p/hansoo-as3/
	 */
	public class HBitmap extends Bitmap
	{
		
		/**
		 * GLBitmap constructor
		 * @param pixelWidth
		 * @param pixelHeight
		 * @param transparency
		 */
		public function HBitmap(pixelWidth:uint, pixelHeight:uint, transparency:Boolean = false)
		{
			Hansune.copyright();
			
            super();
			bitmapData = new BitmapData(pixelWidth, pixelHeight, transparency, 0);
			
			
		}

		/**
		 * set up the anti_aliasing of edge
		 * @default 
		 */
		public var anti_aliasing:Boolean = false;
		
		private var _fillColor:uint = 0xffffff;
		private var _lineColor:uint = 0xffffff;
		private var _reso:uint = 50;
		//private var bd:BitmapData;
		private var canvas:Shape = new Shape();
		private var out_pts:Vector3DArray = new Vector3DArray(50);
	
		/**
		 * draw method for b-spline line
		 * @param v_array Vector3DArray, a array has Vector3D elements over three.
		 * @param curving how much 
		 * @param useFlash draw a shape by flash API (Graphics)
		 */
		public function bSpline(v_array:Vector3DArray, curving:Number = 0.5, useFlash:Boolean = false):void {
			
			//var out_pts:Vector3DArray = new Vector3DArray(resolution);
			if(v_array.length < 3) return;
			HGraphics.bSpline(v_array.length - 1, uint((v_array.length - 2) * curving), v_array, out_pts, _reso);
			
			var i:uint;
			if(useFlash){
				canvas.graphics.moveTo(out_pts[0].x, out_pts[0].y);
				canvas.graphics.lineStyle(1,_lineColor, 1);
				for(i=1; i < _reso; i++){
					canvas.graphics.lineTo(out_pts[i].x, out_pts[i].y);
				}
				bitmapData.draw(canvas);
				canvas.graphics.clear();
			} else {
				for(i=0; i < _reso - 1; i++){
					if(anti_aliasing){
						lineAnti(out_pts[i].x, out_pts[i].y, out_pts[i+1].x, out_pts[i+1].y);
					} else {
						line(out_pts[i].x, out_pts[i].y, out_pts[i+1].x, out_pts[i+1].y);
					}
				}
				
				//bitmapData.fillRect(bitmapData.rect,0);
			}
		}
		
		/**
		 * draw a circle
		 * @param centerX
		 * @param centerY
		 * @param r
		 */
		public function circle(centerX:int, centerY:int, r:int):void
		{
			if(anti_aliasing) {
				aaCircle(centerX, centerY, r);
				return;
			}			
			  var r:int;
			  var xx:int = 0;
			  var yy:int = r;
			  var d:Number = 1-r;//(5-4*r)/2;
			  bitmapData.setPixel(centerX+xx,centerY+yy,_lineColor);
			  bitmapData.setPixel(centerX+xx,centerY-yy,_lineColor);
			  bitmapData.setPixel(centerX-yy,centerY+xx,_lineColor);
			  bitmapData.setPixel(centerX+yy,centerY+xx,_lineColor);
			  
			  while (xx<yy) {
			    ++xx;
			    if(d<0){
			      d += (xx << 1) + 1;//2*xx+1;
			    } else {
			      --yy;
			      d += ((xx - yy) << 1) + 1;//2*(xx - yy)+1;
			    }
			    
			    bitmapData.setPixel(centerX+xx,centerY+yy,_lineColor);
				bitmapData.setPixel(centerX+xx,centerY-yy,_lineColor);
				bitmapData.setPixel(centerX-xx,centerY+yy,_lineColor);
				bitmapData.setPixel(centerX-xx,centerY-yy,_lineColor);
				
				bitmapData.setPixel(centerX+yy,centerY+xx,_lineColor);
				bitmapData.setPixel(centerX+yy,centerY-xx,_lineColor);
			    bitmapData.setPixel(centerX-yy,centerY+xx,_lineColor);
				bitmapData.setPixel(centerX-yy,centerY-xx,_lineColor);
			  }
		}
		
		/**
		* Draw an anti-aliased circle
		* 
		* @param px		first point x coord
		* @param py		first point y coord 
		* @param r		radius
		*/
		private function aaCircle ( px:int, py:int, r:int):void
		{
			var vx:int;
			var vy:int;
			var d:int;
			vx = r;
			vy = 0;
			
			var t:Number=0;
			var dry:Number;
			var buff:int;
				
			bitmapData.setPixel(px+vx,py+vy,_lineColor);
			bitmapData.setPixel(px-vx,py+vy,_lineColor);
			bitmapData.setPixel(px+vy,py+vx,_lineColor);
			bitmapData.setPixel(px+vy,py-vx,_lineColor);
				
			while ( vx > vy+1 )
			{
				vy++;
				buff = Math.sqrt(r*r-vy*vy)+1;
				dry = buff - Math.sqrt(r*r-vy*vy);
				if (dry<t) vx--;
				
				drawAlphaPixel(px+vx,py+vy,1-dry,_lineColor)
				drawAlphaPixel(px+vx-1,py+vy,dry,_lineColor)
				drawAlphaPixel(px-vx,py+vy,1-dry,_lineColor)
				drawAlphaPixel(px-vx+1,py+vy,dry,_lineColor)
				drawAlphaPixel(px+vx,py-vy,1-dry,_lineColor)
				drawAlphaPixel(px+vx-1,py-vy,dry,_lineColor)
				drawAlphaPixel(px-vx,py-vy,1-dry,_lineColor)
				drawAlphaPixel(px-vx+1,py-vy,dry,_lineColor)
			
				drawAlphaPixel(px+vy,py+vx,1-dry,_lineColor)
				drawAlphaPixel(px+vy,py+vx-1,dry,_lineColor)
				drawAlphaPixel(px-vy,py+vx,1-dry,_lineColor)
				drawAlphaPixel(px-vy,py+vx-1,dry,_lineColor)
				
				drawAlphaPixel(px+vy,py-vx,1-dry,_lineColor)
				drawAlphaPixel(px+vy,py-vx+1,dry,_lineColor)
				drawAlphaPixel(px-vy,py-vx,1-dry,_lineColor)
				drawAlphaPixel(px-vy,py-vx+1,dry,_lineColor)
				
				t=dry;
			}
		}
		
		/**
		* Draw an alpha32 pixel
		*/
		private function drawAlphaPixel ( x:int, y:int, a:Number, c:Number ):void
		{	
			var g:uint = bitmapData.getPixel32(x,y);
			
			var r0:uint = ((g & 0x00FF0000) >> 16);
			var g0:uint = ((g & 0x0000FF00) >> 8);
			var b0:uint = ((g & 0x000000FF));
			
			var r1:uint = ((c & 0x00FF0000) >> 16);
			var g1:uint = ((c & 0x0000FF00) >> 8);
			var b1:uint = ((c & 0x000000FF));
			
			var ac:Number = 0xFF;
			var rc:Number = r1*a+r0*(1-a);
			var gc:Number = g1*a+g0*(1-a);
			var bc:Number = b1*a+b0*(1-a);
			
			var n:uint = (ac<<24)+(rc<<16)+(gc<<8)+bc;
			bitmapData.setPixel32(x,y,n);
		}

		/**
		 * 
		 * @return 
		 */
		public function get fillColor():uint {
			return _fillColor;
		}
		/**
		 * 
		 * @param value
		 */
		public function set fillColor(value:uint):void {
			_fillColor = value;
		}
		
		/**
		 * 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 */
		public function line(x1:int, y1:int, x2:int, y2:int):void
		{

			var dx:int, dy:int;
			var p_value:int;
			var inc_minus:int;
			var inc_plus:int;
			var inc_value:int;
			var ndx:int;		
		
			dx = Math.abs(x2 - x1);
			dy = Math.abs(y2 - y1);
		        //변화폭을 따져 완만한 좌표를 기준으로 점을 찍는다.
			if(dy <= dx){
		               // y 보다 x 변화폭이 클 경우
				inc_minus = 2*dy;
				inc_plus = 2*(dy-dx);
				
		                //선 x 점을 작은 수부터 그려나가기 위해.
		                //Bresenham 공식은 다음점에 대한 위치를 잡는 것이기 때문에도.
				if(x2<x1){
					
					ndx = x1;
					x1 = x2;
					x2 = ndx;
					
					ndx = y1;
					y1 = y2;
					y2 = ndx;
				}
				//x 값에 따른 y값 변화값 고르기
				if(y1 < y2){
					inc_value = 1;
				} else {
					inc_value = -1;
				}
				
				bitmapData.setPixel32(x1,y1,_lineColor);
				//처음 판단 값
				p_value = 2*dy-dx;
				
				for(ndx = x1; ndx<x2; ++ndx){
					if(0>p_value){
						p_value += inc_minus;
					} else {
						p_value += inc_plus;
						y1 += inc_value;
					}
					
					bitmapData.setPixel32(ndx, y1, _lineColor);
				}
			}
			else
			{
				inc_minus= 2*dx;
				inc_plus= 2*(dx-dy);
				
				if(y2 < y1){
					ndx = y1;
					y1 = y2;
					y2 = ndx;
					
					ndx = x1;
					x1 = x2;
					x2 = ndx;
				}
				
				if(x1<x2){
					inc_value = 1;
				} else {
					inc_value = -1;
				}
				
				bitmapData.setPixel32(x1,y1,_lineColor);
				
				p_value = 2*dx - dy;
				
				for(ndx = y1;ndx < y2;++ndx){
					if(0>p_value){
						p_value += inc_minus;
					} else {
						p_value += inc_plus;
						x1 += inc_value;
					}
					
					bitmapData.setPixel32(x1, ndx, _lineColor);
				}
			}
		}
		
		/**
		 * drawing a anti-aliasing line 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 */
		public function lineAnti(x1:Number, y1:Number, x2:Number, y2:Number):void {
			
			var nn:Number;
			var dx:Number;
			var dy:Number;
			//gradient of the line
			var grad:Number;
				
			//if the slope is same or lower than 1
			dx = x1 - x2;
			dy = y1 - y2;
			
			if(Math.abs(dx) > Math.abs(dy)){
				
				//if line is back to front
				if(x2 < x1){
					nn = x1;
					x1 = x2;
					x2 = nn;
					
					nn = y1;
					y1 = y2;
					y2 = nn;
				}
				
				dx = x2 - x1;
				dy = y2 - y1;
				
				grad = dy /dx;
				
				//start point : integer more closer to x1
				var xs:int = int(x1 + .5);
				//y position at xs
				var ys:Number = y1+ grad*(xs - x1);
				
				var ixs:int = xs;
				var iys:int = int(ys);
				// effect from x1
				var xgap:Number = 1 - (x1 + .5)%1;
				
				bitmapData.setPixel32(ixs,iys, setAlpha(_lineColor,(1 - (ys%1)) * xgap));
				bitmapData.setPixel32(ixs,iys + 1, setAlpha(_lineColor,(ys%1) * xgap));
				
				// end point : integer more closer to x2
				var xe:int = int(x2 + .5);
				//y position at xe
				var ye:Number = y2 + grad*(xe - x2);
				xgap = (x2 + .5)%1;
				var ixe:int = xe;
				var iye:int = int(ye);
				
				bitmapData.setPixel32(ixe,iye,setAlpha(_lineColor,(1-(ye%1)) * xgap));
				bitmapData.setPixel32(ixe,iye+1, setAlpha(_lineColor,(ye%1) * xgap));
				
				//ixs + 1 ~ ixe -1
				// y position next to xs
				var yy:Number = ys + grad;
				
				for(var ix:int = ixs+1; ix<ixe;ix++){
					bitmapData.setPixel32(ix, int(yy), setAlpha(_lineColor,1-(yy%1)));
					bitmapData.setPixel32(ix, int(yy)+1, setAlpha(_lineColor,(yy%1)));
					yy += grad;
				}
			
			//if the slope is bigger than 1
			//handle the vertical(ish) lines in the same way as the horizontal(ish) ones 
		    //but swap the roles of X and Y
			} else {
				
				//if line is back to front
				if(y2 < y1){
					nn = x1;
					x1 = x2;
					x2 = nn;
					
					nn = y1;
					y1 = y2;
					y2 = nn;
				}
				
				dx = x2 - x1;
				dy = y2 - y1;		
				grad = dx /dy;
				
				//start point : integer more closer to y1
				var ys_v:int = int(y1 + .5);
				//x position at ys
				var xs_v:Number = x1+ grad*(ys_v - y1);
				
				var iys_v:int = ys_v;
				var ixs_v:int = int(xs_v);
				// effect from y1
				var ygap:Number = 1-(y1 + .5)%1;
				
				bitmapData.setPixel32(ixs_v,iys_v, setAlpha(_lineColor,(1 - (xs_v%1)) * ygap));
				bitmapData.setPixel32(ixs_v+1,iys_v, setAlpha(_lineColor,(xs_v%1) * ygap));
				
				// end point : integer more closer to y2
				var ye_v:int = int(y2 + .5);
				//y position at xe
				var xe_v:Number = x2 + grad*(ye_v - y2);
				ygap = (y2 + .5)%1;
				var iye_v:int = ye_v;
				var ixe_v:int = int(xe_v);
				
				bitmapData.setPixel32(ixe_v,iye_v,setAlpha(_lineColor,(1-(xe_v%1)) * ygap));
				bitmapData.setPixel32(ixe_v+1,iye_v, setAlpha(_lineColor,(xe_v%1) * ygap));
				
				//iys_v + 1 ~ iye -1
				// x position next to ys_v
				var xx:Number = xs_v + grad;
				
				for(var iy:int = iys_v+1; iy<iye_v;iy++){
					bitmapData.setPixel32(int(xx),iy, setAlpha(_lineColor,1-(xx%1)));
					bitmapData.setPixel32(int(xx)+1,iy, setAlpha(_lineColor,(xx%1)));
					xx += grad;
				}
			}
		}
		
		
		/**
		 * 
		 * @return 
		 */
		public function get lineColor():uint {
			return _lineColor;
		}
		/**
		 * 
		 * @param value
		 */
		public function set lineColor(value:uint):void {
			_lineColor = value;
		}
		/**
		 * 
		 * @param value
		 */
		public function set resolution(value:uint):void {
			out_pts = new Vector3DArray(value);
			_reso = value;
		}
		
		/**
		* Draw a triangle
		* 
		* @param x0		first point x coord
		* @param y0		first point y coord 
		* @param x1		second point x coord
		* @param y1		second point y coord
		* @param x2		third point x coord
		* @param y2		third point y coord
		*/
		
		public function triangle ( x0:int, y0:int, x1:int, y1:int, x2:int, y2:int):void
		{
			line (x0,y0,x1,y1);
			line (x1,y1,x2,y2);
			line (x2,y2,x0,y0);
		}

		private function setAlpha(c:uint, e:Number):uint {
			var a:uint = c >> 24 & 0xFF;
			var r:uint = c >> 16 & 0xFF;
			var g:uint = c >> 8 & 0xFF;
			var b:uint = c & 0xFF;
			
			// alpha
	        a += uint(e * 255);
	        if (a >255)
	        {
	            a = 255;
	        }
	        if (a <0)
	        {
	            a = 0;
	        }
	        			
			var color2:uint = (r << 16) | (g << 8) | (b);
			return color2;
		}
		
		public static  function getReflectionBitmapData(
			source:BitmapData, 
			reflectionHeight:Number,
			reflectionTransparent:Boolean = true ,
			distance:Number = 0 ,
			reflectionAlpha:Number = 0.35 ,
			reflectionBgColor:uint = 0x00000000  ) : BitmapData {
			var sw:Number = source.width;
			var sh:Number = source.height;
			var refH:Number = reflectionHeight;
			var returnData:BitmapData = new BitmapData( sw , sh + refH + distance  , true , 0 );
			
			var temp:BitmapData = new BitmapData(sw, sh, true, 0);
			var mat:Matrix = new Matrix();
			mat.scale(1, -1);
			mat.translate(0, source.height);
			temp.draw(source, mat);
			
			var grs:Shape = getGradientShape( sw , refH );
			var grd:BitmapData = new BitmapData( sw , refH , true , 0 );
			grd.draw( grs );
			
			returnData.copyPixels( temp , temp.rect , new Point(0, sh+distance ) , grd );
			returnData.draw( source );
			temp.dispose();
			return returnData;
		}
		
		public static function reverseVertical(data:BitmapData):BitmapData {
			var temp:BitmapData = new BitmapData(data.width, data.height , true , 0);
			var m:Matrix = new Matrix();
			m.scale(1, -1);
			m.translate(0, data.height);
			temp.draw(data , m);
			
			return temp;
		}
		
		private static function getGradientShape(w:Number,h:Number):Shape {
			var color:uint = 0;
			var color2:uint = 0;
			var gradientColor: Array = 	[ 	color, 		color2];
			var gradientAlpha: Array = 	[ 	0.5, 		0 ];
			var gradientRatio: Array = 	[ 	0,		255];
			var gradientMatrix: Matrix = new Matrix();
			gradientMatrix.identity();
			var min:Number = Math.min( w ,h );
			
			gradientMatrix.createGradientBox( min ,min, Math.PI / 2 );
			
			var gradientMask: Shape = new Shape();
			gradientMask.graphics.clear();
			gradientMask.graphics.beginGradientFill( GradientType.LINEAR, gradientColor, gradientAlpha, gradientRatio, gradientMatrix, SpreadMethod.PAD );
			gradientMask.graphics.drawRect( 0, 0,w,h );
			gradientMask.graphics.endFill();
			return gradientMask;
		}
	}
}