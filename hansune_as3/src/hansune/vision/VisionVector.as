package hansune.vision
{
	public class VisionVector
	{
		public var vx:Number = 0;
		public var vy:Number = 0;
		
		
		public function VisionVector(vLength:Number=0, hLength:Number=0)
		{
			vx = vLength;
			vy = hLength;
		}
		
		public function length():Number
		{
			return Math.sqrt(vx*vx + vy*vy);
		}
		
		public function clone():VisionVector
		{
			return new VisionVector(vx,vy);
		}

	}
}