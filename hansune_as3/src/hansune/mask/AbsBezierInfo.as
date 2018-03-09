package hansune.mask
{
	import flash.geom.Point;
	
	public class AbsBezierInfo
	{
		public var x:Number;
		public var y:Number;
		public var position:Vector.<Point>;
		public var positionNums:uint = 0;
		public var style:String;
		public var round:Number = 0;
				
		public function AbsBezierInfo()
		{
		}
		
		public function clone():AbsBezierInfo{
			throw Error("function in abstract class");
		}
		
		public function getSaveString():String
		{
			var txt:String = "// "+ style + " rectangle mask info\n";
			for(var i:int=0; i< positionNums; ++i){
				txt += "handle"+i+ " " + position[i].x + "_" + position[i].y + "\n";
			}
			txt += "round " + round + "\n";
			txt += "x " + this.x + "\n";
			txt += "y " + this.y;
			
			return txt;
		}
		
		public function toString():String 
		{
			var txt:String = "++ "+ style + " mask info ++ \n";
			for(var i:int=0; i< positionNums; ++i){
				txt += "handle"+i+ " " + position[i].x + " " + position[i].y + " : ";
			}
			txt += "round " + round;
			txt += "\n";
			txt += "x " + this.x + "\n";
			txt += "y " + this.y;
			return txt;
		}

	}
}