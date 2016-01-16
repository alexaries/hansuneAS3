package  
{
	import hansune.viewer.zoomViewer.*;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	[SWF(width = '1024', height = '768', backgroundColor = '#000000', frameRate = '60')]
	public class zoomViewerEx extends Sprite {
		private var zoomViewer:ZoomViewer;
		
		public function zoomViewerEx() {
			
			zoomViewer = new ZoomViewer();
			zoomViewer.file = "../data/kim.jpg";
			zoomViewer.x = 100;
			zoomViewer.y = 100;
			zoomViewer.viewedRectangle = new Rectangle(100,100,400,500);
			zoomViewer.start();
			addChild(zoomViewer);
		}
	}
}