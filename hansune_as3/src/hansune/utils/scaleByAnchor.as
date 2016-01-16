package hansune.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
    /**
     * 특정 위치를 기준으로 스케일 변화시키는 함수
     */
	public function scaleByAnchor(target:DisplayObject, anchor:Point, valueX:Number, valueY:Number):void {
		
		var originalWdith:Number = target.width / target.scaleX;
		var originalHeight:Number = target.height / target.scaleY;
		var xRate:Number = target.globalToLocal(anchor).x / originalWdith;
		var yRate:Number = target.globalToLocal(anchor).y / originalHeight;
		var beforeWidth:Number = target.width;
		var beforeHeight:Number = target.height;
		
		//trace("originalWdith " +originalWdith+" / originalHeight " + originalHeight);
		//trace("target.globalToLocal(anchor).x " +target.globalToLocal(anchor).x+" / target.globalToLocal(anchor).y " + target.globalToLocal(anchor).y);
		
		target.scaleX = valueX;
		target.x = target.x - ((target.width - beforeWidth) * xRate);
		target.scaleY = valueY;
		target.y = target.y - ((target.height - beforeHeight) * yRate);
	}
}
