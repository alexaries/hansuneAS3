package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * @author mrdoob
	 */
	[SWF(width="800",height="600",backgroundColor="#000000",frameRate="50")]	 
	public class LSD extends Sprite 
	{
		private var message : TextField;
				
		private var camera : Camera;
		private var video : Video;
		private var bitmap : Bitmap;
		private var bitmapdata : BitmapData;
		private var container : Sprite;
		private var output : Sprite;

		public function LSD() 
		{
			stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			container = new Sprite();			
			output = new Sprite();
			addChild(output);
						
			message = new TextField();
			message.defaultTextFormat = new TextFormat("Arial", 10, 0xffffff);
			message.text = "I'm afraid you need a webcam to play with this toy :(";
			message.autoSize = TextFieldAutoSize.CENTER;
			message.visible = false;		
			centerMessage();
			addChild(message);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			if (!Camera.names.length)
			{
				message.visible = true;
				return;
			}
			
			camera = Camera.getCamera();
			camera.setMode(640, 480, 30);			
			camera.addEventListener(StatusEvent.STATUS, cameraStatusHandler);
			video = new Video(camera.width, camera.height);
			video.attachCamera(camera);
			video.scaleX = -1;
			video.x += video.width;
			container.addChild(video);
		
			bitmapdata = new BitmapData(container.width, container.height, false, 0);
			bitmap = new Bitmap(bitmapdata);
			bitmap.blendMode = BlendMode.OVERLAY;
			
			container.addChild(bitmap);
			output.addChild(new Bitmap(bitmapdata, "auto", true));
			
			centerOutput();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame( e : Event ) : void
		{
			bitmapdata.applyFilter(bitmapdata, bitmapdata.rect, new Point, new BlurFilter(4, 4, 1));
			bitmapdata.draw(container, null, null, BlendMode.NORMAL);
		}
		
		// .. CAMERA STATUS
		
		private function cameraStatusHandler( e : StatusEvent ) : void
		{
		    switch (e.code)
		    {
		        case "Camera.Muted":
		        	output.visible = false;		        
		        	message.visible = true;
		            break;
		        case "Camera.Unmuted":
		        	output.visible = true;		        
		        	message.visible = false;	        
		            break;
		    }
		}
		
		// .. LAYOUT
		
		private function onStageResize( e : Event ) : void
		{
			centerMessage();			
			centerOutput();
		}
		
		private function centerOutput() : void
		{
			output.width = stage.stageWidth;
			output.height = stage.stageHeight;						
		}
		
		private function centerMessage() : void
		{
			message.x = (stage.stageWidth >> 1) - (message.width >> 1);
			message.y = stage.stageHeight >> 1;
		}
	}
}