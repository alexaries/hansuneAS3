package hansune.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author hansoo
	 */
		
	public function setTint(object:DisplayObject,clr:uint, phaseIn:Boolean = true):void{
		var ct:ColorTransform = new ColorTransform();
		var i:int;
		var color:uint = object.transform.colorTransform.color;
		var tgColor:uint = clr;
		
		if (color == tgColor) return;
		
		var red:Number = color >>> 16 & 0xFF;
		var green:Number = color >>> 8 & 0xFF;
		var blue:Number = color & 0xFF;
		var tgRed:Number = tgColor >>> 16 & 0xFF;
		var tgGreen:Number = tgColor >>> 8 & 0xFF;
		var tgBlue:Number = tgColor & 0xFF;
		
		if(object.hasEventListener(Event.ENTER_FRAME)){
			object.removeEventListener(Event.ENTER_FRAME,transClr);
		}
		
		if(phaseIn)	{object.addEventListener(Event.ENTER_FRAME,transClr)}
		else {
			ct.color = tgColor;
			object.transform.colorTransform = ct;
		};
		
		function transClr(e:Event):void{
			
			//color change
			if(Math.abs(tgRed - red)<1){
				red = tgRed;
			} else {
				red += (tgRed - red)*0.05;
			}
			
			if(Math.abs(tgGreen - green)<1){
				green = tgGreen;
			} else {
				green += (tgGreen - green)*0.05;
			}
			
			if(Math.abs(tgBlue - blue)<1){
				blue = tgBlue;
			} else {
				blue += (tgBlue - blue)*0.05;
			}
			
			color = (red << 16) | (green << 8) | (blue);
			ct.color = color;
			object.transform.colorTransform = ct;
			
			if(tgColor == color) {
				object.removeEventListener(e.type,transClr);
				ct.color = clr;
			}
		}
	}
}
