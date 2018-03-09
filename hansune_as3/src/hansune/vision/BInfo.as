package hansune.vision 
{
	public class BInfo
	{
		public var dotX:Vector.<Number>;
		public var dotY:Vector.<Number>;
		public var dotN:uint;
        public function BInfo() {
			dotX = new Vector.<Number>(10000);
			dotY = new Vector.<Number>(10000);
			dotN = 0;
			/*
			for (var i:int = 0; i<10000; i++) {
				dotX[i] = 0;
				dotY[i] = 0;
			}
			*/
		}
	}
	
	
}