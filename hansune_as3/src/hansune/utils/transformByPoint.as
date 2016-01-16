//무비클립의 중심위치 이동하는 클래스
//만든 사람 : 한상훈
////////////////////////////////////////////////////////////
//import com.hansune.utils.transformByPoint;
//var box:Sprite = new Sprite();
//box.graphics.beginFill(0xffaa00);
//box.graphics.drawRect(100,100,200,200);
//box.graphics.endFill();
//this.addChild(box);
//var point:Point = new Point(0,0);
//transformByPoint(point, box,"rotation", 10);
////////////////////////////////////////////////////////////

package hansune.utils
{
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public function transformByPoint(anchorPoint:Point, target:DisplayObject, property:String, value:Number):void{
		var a:Point = target.parent.globalToLocal(target.localToGlobal(anchorPoint));
		target[property]=value;
		var b:Point = target.parent.globalToLocal(target.localToGlobal(anchorPoint));
		target.x = b.x - a.x;
		target.y = b.x - a.y;
	}
}
