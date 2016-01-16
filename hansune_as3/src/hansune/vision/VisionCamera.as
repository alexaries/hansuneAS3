package hansune.vision
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	
	import hansune.Hansune;

	public class VisionCamera extends Bitmap {

		internal var camera:Camera;
		
		private var video:Video;
		private var thresBD:BitmapData;
		private var blackBD:BitmapData;
		private var pt:Point = new Point(0, 0);
		private var rect:Rectangle;

		public var threshold:uint = 0x00808080; 
		public var thresholdColor:uint = 0xffff0000;
		public var maskColor:uint = 0x00ffffff;
		public var displayBD:BitmapData;//카메라 출력 이미지
		public var bsInfo:Vector.<BInfo>;
		public const bsInfoMax:int = 500;
		public var bsInfoCount:uint;
		public var visited:Vector.<uint>;
		public var xchain:Vector.<uint>;
		public var ychain:Vector.<uint>;
		public var capBoxW:uint;
		public var capBoxH:uint;
		public var borderBack:Shape;
		public var tempArray:ByteArray;
		public var cameraMode:String;

		public function VisionCamera(captureWidth:uint = 320, captureHeight:uint = 240, mode:String = "block") {

			Hansune.copyright();
			
			capBoxW = captureWidth;
			capBoxH = captureHeight;
			cameraMode = mode;

			displayBD = new BitmapData(capBoxW, capBoxH, false, 0);				
			super(displayBD);

		}

		public function init():void
		{

			camera = Camera.getCamera();

			if (camera != null) {

				tempArray = new ByteArray();
				camera.setQuality(16384, 50);
				camera.setMode(capBoxW,capBoxH, 30);
				camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);

				rect = new Rectangle(0, 0, capBoxW, capBoxH);

				video = new Video(capBoxW,capBoxH);
				video.cacheAsBitmap = true;
				video.attachCamera(camera);

				thresBD = new BitmapData(capBoxW,capBoxH, false, 0);
				blackBD = new BitmapData(capBoxW, capBoxH, false, 0);			
				borderBack = new Shape();

				bsInfoCount = 0;
				bsInfo = new Vector.<BInfo>(bsInfoMax);
				for (var i:int = 0; i<bsInfoMax; i++) {
					bsInfo[i] = new BInfo();
				}

				visited = new Vector.<uint>(capBoxH*capBoxW);
				xchain = new Vector.<uint>(capBoxH*capBoxW);
				ychain = new Vector.<uint>(capBoxH*capBoxW);
				
				
				cmf = new ColorMatrixFilter(grayMatrix);

				this.addEventListener(Event.ENTER_FRAME, enterframeEvents);

			} else {
				trace("You need a camera.");
			}


		}

		public function cloneImage():Bitmap
		{
			return new Bitmap(displayBD);
		}

		private function enterframeEvents(e:Event):void {

			switch(cameraMode) {
				case VisionCameraMode.REAL :
					displayBD.draw(video);
					break;
				case VisionCameraMode.THRESHOLD :
					drawThres();
					break;
				case VisionCameraMode.BORDER :
					drawBorder();
					break;
				case VisionCameraMode.BLOCK :
					drawBlock();
					break;
				case VisionCameraMode.GRAY :
					drawGray();
					break;
			} 

		}
		
		private var change:Event = new Event(Event.CHANGE);

		private function drawThres():void{
			displayBD.lock();
			displayBD.copyPixels(blackBD, rect,pt);
			displayBD.unlock();
			thresBD.draw(video);
			displayBD.threshold(thresBD, rect, pt, "<", threshold, thresholdColor, maskColor, false);
			
			dispatchEvent(change);
			
			//displayBD.copyPixels(thresBD, rect, pt);
			//displayBD.copyChannel(thresBD, rect, pt,0x00ff000,0xffff0000);
		}
		
		private var grayMatrix:Array = [    0.299, 0.587, 0.114, 0, 0, 
			            0.299, 0.587, 0.114, 0, 0, 
			            0.299, 0.587, 0.114, 0, 0, 
			            0, 0, 0, 1, 0]; 
		private var cmf:ColorMatrixFilter;
		private function drawGray():void {
			displayBD.lock();
			displayBD.draw(video);
			displayBD.applyFilter(displayBD, displayBD.rect, pt, cmf); 
			displayBD.unlock();
			
			dispatchEvent(change);
		}

		private function drawBorder():void
		{
			thresBD.draw(video);
			thresBD.threshold(thresBD, rect, pt, "<", threshold, thresholdColor, maskColor, false);
			tempArray = thresBD.getPixels(rect);

			borderTracking();

			borderBack.graphics.clear();

			for (var i:int = 0; i<bsInfoCount; ++i) 
			{
				borderBack.graphics.lineStyle(0, 0xffff0000);
				borderBack.graphics.moveTo(bsInfo[i].dotX[0], bsInfo[i].dotY[0]);
				for (var j:int = 1; j<bsInfo[i].dotN; ++j) 
				{
					borderBack.graphics.lineTo(bsInfo[i].dotX[j], bsInfo[i].dotY[j]);
				}
				borderBack.graphics.lineTo(bsInfo[i].dotX[0], bsInfo[i].dotY[0]);
			}

			displayBD.lock();
			displayBD.copyPixels(blackBD, rect,pt);
			displayBD.unlock();
			displayBD.draw(borderBack);	
			
			dispatchEvent(change);

		}	

		private function drawBlock():void
		{
			thresBD.draw(video);
			thresBD.threshold(thresBD, rect, pt, "<", threshold, thresholdColor, maskColor, false);
			tempArray = thresBD.getPixels(rect);

			borderTracking();

			borderBack.graphics.clear();

			for (var i:int = 0; i<bsInfoCount; ++i) 
			{
				borderBack.graphics.beginFill(0xffff0000);
				borderBack.graphics.moveTo(bsInfo[i].dotX[0], bsInfo[i].dotY[0]);
				for (var j:int = 1; j<bsInfo[i].dotN; ++j) 
				{
					borderBack.graphics.lineTo(bsInfo[i].dotX[j], bsInfo[i].dotY[j]);
				}
				borderBack.graphics.lineTo(bsInfo[i].dotX[0], bsInfo[i].dotY[0]);
				borderBack.graphics.endFill();
			}

			displayBD.lock();
			displayBD.copyPixels(blackBD, rect,pt);
			displayBD.unlock();
			displayBD.draw(borderBack);	
			
			dispatchEvent(change);

		}	

		private var span:int = 1;
		private var tempBool:Vector.<Boolean> = new Vector.<Boolean>();
		private var nei:Array = [[span, 0], [span, -span], [0, -span], [-span, -span],[-span, 0], [-span, span], [0, span], [span, span]];
		private var x0:int, y0:int, x1:int, y1:int, k:int, n:int;
		private var numberBorder:int=0;
		private var border_count:int, diagonal_count:int;
		private var c0:Boolean, c1:Boolean;
		private var magx:Number;
		private	var magy:Number;
		private	var SIZEDET:Boolean = true;
			
		public function borderTracking():void
		{
			
			if (SIZEDET) {
				magx = 1.0;
				magy = 1.0;
			} else {
				magx = 1024*1.0/capBoxW;
				magy = 768*1.0/capBoxH;
			}

			 nei = [[1, 0], [1, -1], [0, -1], [-1, -1],[-1, 0], [-1, 1], [0, 1], [1, 1]];
			//if(span != 1) nei = [[span, 0], [span, -span], [0, -span], [-span, -span],[-span, 0], [-span, span], [0, span], [span, span]];
						
			for (var i:int=0; i<capBoxH*capBoxW; i++) {
				if ((tempArray[i*4+1])==0xff && (tempArray[i*4+2])==0 && (tempArray[i*4+3])==0)
				//if(((tempArray[i*4] << 24) | (tempArray[i*4+1] << 16) | (tempArray[i*4+2] << 8) | tempArray[i*4+3]) == 0xffff0000)
				{
					tempBool[i] = true;
				} else {
					tempBool[i] = false;
				}
				
				visited[i] = 0;
			}
			/*
			for (var j:int = 0; j<capBoxH*capBoxW; j++) {
				
			}
			*/
			
			numberBorder = 0;
			
			
			for (x1=1; x1<capBoxH; x1++) {
				for (y1=1; y1<capBoxW; y1++) {

					c0 = tempBool[x1*capBoxW + y1];
					c1 = tempBool[(x1-1)*capBoxW + y1];
					if (c0!=c1 && c0 && visited[x1*capBoxW + y1]==0)//c0!=c1 경계 
					{

						border_count=0;//경계점의 개수를 세기 위한 카운터
						diagonal_count=0;//대각선 방향의 경계점 개수를 세는 카운터
						x0=x1; y0=y1;
						n=4;

						do {
							for (k=0; k<8; k++, n=((n+1)&7)) //01234567 
							{
								var u:int = (x1 + nei[n][0]); //?
								var v:int = (y1 + nei[n][1]); //?
								if (u<0 || u>=capBoxH || v<0 || v>=capBoxW) continue;
								if (tempBool[u*capBoxW + v]==c0) break; //경계를 만나면 다음으로 추적 이동
							}
							if (k==8) break;//고립점

							visited[x1*capBoxW + y1] = 255;
							xchain[border_count] = x1; //?
							ychain[border_count++] = y1; //?
							if (border_count>=15000) break;

							x1=x1+nei[n][0]; //?
							y1=y1+nei[n][1]; //?

							if (n%2==1) diagonal_count++;
							n = (n+5) & 7; //01234567
						//} while (!(Math.abs(x1 - x0)<span && Math.abs(y1 - y0)<span));
						} while (!(x1==x0 && y1==y0));

						if (k==8) continue;
						if (border_count >= 15000 || border_count <= 100) continue;//너무 크거나 작으면 무시

						var ddiv:int = 2;
						/*
						if (SIZEDET) {
							ddiv = 2;
						}*/
						
						for (k=0; k<border_count; k+=ddiv) {
							bsInfo[numberBorder].dotX[k/ddiv] = ychain[k] * magx;
							bsInfo[numberBorder].dotY[k/ddiv] = xchain[k] * magy;
						}

						bsInfo[numberBorder].dotN = border_count/ddiv;

						if (border_count > 100) {
							numberBorder++;
						}

						if (numberBorder>=bsInfoMax) break;

					}
				}
			}

			bsInfoCount = numberBorder;

		}


		private function activityHandler(event:ActivityEvent):void {
			//trace("activityHandler: " + event);
		}
	}
}

