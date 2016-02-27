package hansune.display
{
	import flash.display.Sprite;
	
	import hansune.geom.Position;
	import hansune.geom.VFactor;
	
	/**
	 * 벡터 요소를 포함시킨 Sprite 임.
	 * 기본 위치를 지정하고 이전, 이후 위치를 지정한다던가,
	 * 속도값을 통해 움직임을 주기에 용이하게 함
	 * @author hyonsoohan
	 * 
	 */
	public class MSprite extends Sprite implements IDefaultPosition
	{
		/**
		 * 벡터 요소
		 */
		public var v:VFactor = new VFactor();
		
		override public function set x(value:Number):void {
			super.x = value;
			v.x = value;
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			v.y = value;
		}
		
		public var tx:Number, ty:Number, tz:Number;
		
		
		
		/**
		 * 벡터 요소를 포함시킨 Sprite 임.
		 * 기본 위치를 지정하고 이전, 이후 위치를 지정한다던가,
		 * 속도값을 통해 움직임을 주기에 용이하게 함
		 */
		public function MSprite()
		{
			super();
		}
		
		/**
		 * 이전 위치로 이동, 현재 위치에서 속도 빼줌.
		 * 
		 */
		public function prev():void {
			this.x -= v.vx;
			this.y -= v.vy;
		}
		
		/**
		 * 다음 위치로 이동, 현재 위치에서 속도 더해줌.
		 * 
		 */
		public function next():void {
			this.x += v.vx;
			this.y += v.vy;
		}
		
		/**
		 * 이전 위치
		 * @return 
		 * 
		 */
		public function get prevPosition():Position {
			return new Position(v.x - v.vx, v.y - v.vy);
		}
		
		/**
		 * 다음 위치
		 * @return 
		 * 
		 */
		public function get nextPosition():Position {
			return new Position(v.x + v.vx, v.y + v.vy);
		}
		
		/**
		 * 기본 위치
		 */
		protected var dp:Position = new Position();
		
		/**
		 * 기본 위치로 이동
		 * 
		 */
		public function gotoDefault():void {
			this.x = dp.x;
			this.y = dp.y;
		}
		
		
		/**
		 * 기본 위치 지정<br>
		 * set x, y value of defaultPosition
		 * @param x
		 * @param y
		 * 
		 */
		public function setDefaultPosition(x:Number, y:Number):void {
			if(dp == null) dp = new Position();
			dp.x = x;
			dp.y = y;
		}
		
		/**
		 * 기본 위치
		 * @return 
		 * 
		 */
		public function get defaultPosition():Position {
			if(dp == null) return dp;
			return dp;
		}
		
		/**
		 * 기본 위치로부터 이전 위치로 이동
		 * 
		 */
		public function gotoFront():void {
			this.x = dp.x - v.vx;
			this.y = dp.y - v.vy;
		}
		
		/**
		 * 기본 위치로부터 다음 위치로 이동
		 * 
		 */
		public function gotoRear():void {
			this.x = dp.x + v.vx;
			this.y = dp.y + v.vy;
		}
		
		/**
		 * 기본 위치로부터 이전 위치
		 * @return 
		 * 
		 */
		public function get front():Position {
			return new Position(dp.x - v.vx, dp.y - v.vy);
		}
		
		/**
		 * 기본 위치로부터 다음 위치
		 * @return 
		 * 
		 */
		public function get rear():Position {
			return new Position(dp.x + v.vx, dp.y + v.vy);
		}
		
		
		
		/**
		 * 속도 지정
		 * @param vx
		 * @param vy
		 * 
		 */
		public function setVector(vx:Number, vy:Number):void {
			v.vx = vx;
			v.vy = vy;
		}
	}
}