package hansune.viewer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import hansune.Hansune;

	public class MiniScalingView extends Sprite
	{
		internal var viewRect:Rectangle;
		internal var image:DisplayObject;
		private var sourceRect:Rectangle;
		private var sourceViewRect:Rectangle;
		private var thumb:Bitmap;
		private var guide:Shape;
		private var offx:Number;
		private var offy:Number;

		public function set viewWidth(val:Number):void {viewRect.width = val;}
		public function get viewWidth():Number{return viewRect.width;}
		public function set viewHeight(val:Number):void {viewRect.height = val;}
		public function get viewHeight():Number{return viewRect.height;}		

		public var isOutline:Boolean = true;
		public var outlineColor:uint = 0x000000;
		public var outlineAlpha:Number = 1.0;
		public var backgroundColor:uint = 0xffffff; 
		public var backgroundAlpha:Number = 0.5; 
		public var guideColor:uint = 0xff0000;

		/**
		 * ��: �̹��� ���� �����ִ� ����; �˷��ֱ� '��
		 * @param	source ���?
		 * @param	sourceRectangle �����?�������?�ִ� ����
		 * @param	miniWidth �̴Ϻ��� ũ��
		 * @param	miniHeight �̴Ϻ��� ũ��
		 */
		public function MiniScalingView(source:DisplayObject,sourceRectangle:Rectangle,miniWidth:Number = 200, miniHeight:Number = 200):void
		{
			super();
			Hansune.copyright();
			
			viewRect = new Rectangle(0, 0, miniWidth, miniHeight);
			image = source;
			sourceRect = sourceRectangle;
		}

		public function init():void{

			var beforeScaleX:Number = image.scaleX;
			var beforeScaleY:Number = image.scaleY;

			if (image.scaleX != 1.0 || image.scaleY != 1.0) {
				image.visible = false;
				image.scaleX = 1;
				image.scaleY = 1;
			}

			var scale:Number = Math.min(viewRect.width / image.width, viewRect.height / image.height);		
			var desbd:BitmapData = new BitmapData(image.width * scale, image.height * scale);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			desbd.draw(image, matrix);

			image.scaleX = beforeScaleX;
			image.scaleY = beforeScaleY;
			image.visible = true;

			thumb = new Bitmap(desbd); 
			thumb.x = ((viewRect.width - thumb.width) >> 1) >> 0;
			thumb.y = ((viewRect.height - thumb.height) >> 1) >> 0;

			offx = thumb.x;
			offy = thumb.y;

			var back:Shape = new Shape();
			back.graphics.beginFill(backgroundColor,backgroundAlpha);
			if(isOutline)back.graphics.lineStyle(2,outlineColor,outlineAlpha);
			back.graphics.drawRect(viewRect.x, viewRect.y, viewRect.width, viewRect.height);
			back.graphics.endFill();

			guide = new Shape();

			addChild(back);
			addChild(thumb);
			addChild(guide);
			update();
		}

		public function update():void{
			var ratio_w:int = Math.min(viewRect.width,(sourceRect.width / image.width * thumb.width)) >> 0;
			var ratio_h:int = Math.min(viewRect.height,(sourceRect.height / image.height * thumb.height)) >> 0;
			var ratio_x:int = -((image.x / (image.width - sourceRect.width)) * (thumb.width - ratio_w)) >> 0;
			var ratio_y:int = -((image.y / (image.height - sourceRect.height))  *  (thumb.height - ratio_h))>>0; 


			guide.graphics.clear();
			guide.graphics.lineStyle(1,guideColor);
			guide.graphics.drawRect(offx + ratio_x,offy + ratio_y, ratio_w, ratio_h);
		}

		public function dispose():void
		{
			thumb.bitmapData.dispose();
		}
	}
}

