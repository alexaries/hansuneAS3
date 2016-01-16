package  hansune.geom
{
	public class VFactor
	{
		public var x:Number;
		public var y:Number;
		public var vx:Number;
		public var vy:Number;
		
		public function VFactor(x:Number=0, y:Number=0, vx:Number = 0, vy:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.vx = vx;
			this.vy = vy;
		}
		
		public function toString():String {
			return "x : "+x+" y : "+y + "vx : "+vx+" vy : "+vy;
		}
		
		/**
		 * 벡터 크기
		 * @return
		 * */
		public function get length():Number{
			return Math.sqrt(vx * vx + vy * vy);
		}			
	}
}