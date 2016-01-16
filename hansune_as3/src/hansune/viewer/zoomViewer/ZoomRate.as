package hansune.viewer.zoomViewer
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com

	 */
	public class ZoomRate extends Sprite
	{
		private var _tf:TextField;
		
		public function ZoomRate() 
		{
			_tf = new TextField();
			_tf.background = true;
			_tf.backgroundColor = 0xffffff;
			_tf.border = true;
			_tf.borderColor = 0xffff00;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(_tf);
		}
		
		public function set rate(value:Number):void {
			_tf.text = value.toFixed(1);
		}
		
		public function get rate():Number {
			return Number(_tf.text);
		}
		
	}
	
}