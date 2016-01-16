package hansune.vision
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class VisionField extends EventDispatcher
	{
		public var vCount:uint = 10;
		public var hCount:uint = 10;
		private var vectorArray:Vector.<VisionVector>;

		public function VisionField(horizonCount:uint = 10, verticalCount:uint = 10)
		{
			vectorArray = new Vector.<VisionVector>(horizonCount * verticalCount);
			for(var i:int = 0; i<vectorArray.length; ++i){
				vectorArray[i] = new VisionVector();
			}
		}
		
		public function update(bitmapdata:BitmapData):void
		{
			//비트맵을 받아 넘버그리드로 변경.
			//이전 넘버그리드 값과 비교하여 변화량을 벡터로 표현
		}
		
		
		public function setNewVectorAtHV(vec:VisionVector, h:uint, v:uint):void
		{
			vectorArray[(hCount*v) + h] = vec.clone();
		}
		
		public function getVectorAtHV(h:uint, v:uint):VisionVector 
		{	
			return vectorArray[(hCount*v) + h];
		}

	}
}

