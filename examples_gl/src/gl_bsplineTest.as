//------------------------------------------------------------------------------
//
//   Copyright 2010 
//   hansune.com All rights reserved. 
//   CC : Attribution-Noncommercial-Share Alike 2.0 Korea 
// 
//   I would like to thank every one of you for helping me out. 
//
//------------------------------------------------------------------------------

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import hansune.gl.HGraphics;
	import hansune.gl.Vector3DArray;
	
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class gl_bsplineTest extends Sprite
	{
		
		public function gl_bsplineTest()
		{
			var bmd:BitmapData = new BitmapData(1024, 768, false, 0);
			var bm:Bitmap = new Bitmap(bmd);
			
			var n:int, t:int, i:int;
			n=7;
			t=4;
			
			var pts:Vector3DArray; 
			pts = new Vector3DArray(n+1);
			
			pts[0].x=10;  pts[0].y=100;  pts[0].z=0;
			pts[1].x=200;  pts[1].y=100;  pts[1].z=0;
			pts[2].x=345;  pts[2].y=300;  pts[2].z=0;
			pts[3].x=400;  pts[3].y=250;  pts[3].z=0;
			pts[4].x=500;  pts[4].y=550;  pts[4].z=0;
			pts[5].x=550;  pts[5].y=150;  pts[5].z=0;
			pts[6].x=570;  pts[6].y=50;   pts[6].z=0;
			pts[7].x=600;  pts[7].y=100;  pts[7].z=0;
			
			var resolution:int = 100;
			var out_pts:Vector3DArray = new Vector3DArray(resolution);
			
			HGraphics.bSpline(n, t, pts, out_pts, resolution);
			
			for(i=0; i<=n; i++) {
				bmd.setPixel(pts[i].x, pts[i].y, 0xff0000);
			}
			
			for(i=0; i<resolution; i++){
				bmd.setPixel(out_pts[i].x, out_pts[i].y, 0x00ff00);
			}
			
			addChild(bm);
			
		}
	}
}