package hansune.display
{
	import hansune.geom.Position;

	public interface IDefaultPosition
	{
		/**
		 * 기본 위치 지정<br>
		 * set x, y value of defaultPosition
		 * @param x
		 * @param y
		 * 
		 */
		function setDefaultPosition(x:Number, y:Number):void;
		
		/**
		 * 기본 위치
		 * @return
		 */
		function get defaultPosition():Position;
		
		/**
		 * 기본 위치로 이동
		 * 
		 */
		function gotoDefault():void;
	}
}