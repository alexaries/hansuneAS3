package hansune.utils
 {
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class alert {
		
		private static var _x:int = 0;
		private static var _y:int = 0;
		private static var alertTime:Number;
		private static var isViewing:Boolean = false;
		private static var lb:TextField = new TextField();
		private static var _container:DisplayObjectContainer;
		
		public static function set x(value:int):void {
			_x = value;
			lb.x = _x;
		}
		
		public static function set y(value:int):void {
			_y = value;
			lb.y = _y;
		}
		
		public static function show(container:DisplayObjectContainer, errMsg:String,isHideChk:Boolean = true, time:int = 3000):void{
			
			
			if(isViewing){
				clearTimeout(alertTime);
				hideLabel();
			}
			_container = container;
			isViewing = true;
			lb.mouseEnabled = false;
			lb.background = true;
			lb.backgroundColor = 0xffffff;
			lb.border = true;
			lb.autoSize = TextFieldAutoSize.LEFT;
			lb.alpha = 0.7;
			lb.x = _x;
			lb.y = _y;
			lb.text = errMsg;
			
			_container.addChild(lb);
			
			if(isHideChk){
				alertTime = setTimeout(hideLabel,time);
			}
			
		}
		private static function hideLabel():void{
			lb.y = -500;
			isViewing = false;
			if(_container.contains(lb))_container.removeChild(lb);
		}
	}
}