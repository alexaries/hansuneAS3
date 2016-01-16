//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

package hansune.geom
{
	import flash.geom.Point;
	
	/**
	 *
	 * @author hansoo
	 */
	public class Vector2D extends VFactor
	{
		
		/**
		 * Vector2d 생성
		 * @param point0x 시작점 x
		 * @param point0y 시작점 y
		 * @param x_velocity 속도 x
		 * @param y_velocity 속도 y
		 */
		public function Vector2D(vectorFactor:VFactor)
		{
			_factor = vectorFactor;
			this.x = vectorFactor.x;
			this.y = vectorFactor.y;
			this.vx = vectorFactor.vx;
			this.vy = vectorFactor.vy;
			_p0 = new Point(vectorFactor.x,vectorFactor.y);
			_p1 = new Point(vectorFactor.x + vectorFactor.vx, vectorFactor.y + vectorFactor.vy);
			_left = new VFactor(vectorFactor.x, vectorFactor.y, vectorFactor.vy, -vectorFactor.vx);
			_right = new VFactor(vectorFactor.x, vectorFactor.y, -vectorFactor.vy, vectorFactor.vx);
			_normal = new VFactor(vectorFactor.x,vectorFactor.y, vx/length, vy/length);
		}

		/**
		 *
		 * @param vector
		 * @return
		 */
		static public function getAngle(vector:VFactor):Number {
			return Math.atan2(vector.vy, vector.vx);
		}

		/**
		 * get dot product from 2 vectors
		 * @param vector0
		 * @param vector1
		 * @return
		 */
		static public function getDotProduct(vector0:VFactor, vector1:VFactor):Number{
			return vector0.vx*vector1.vx + vector0.vy * vector1.vy;
		}


		/**
		 *
		 * @param vector
		 * @return
		 */
		static public function getLength(vector:VFactor):Number {
			return Math.sqrt(vector.vx * vector.vx + vector.vy * vector.vy);
		}

		/**
		 * 두 포인트2d 로 벡터를 구함
		 * @return
		 * */
		static public function getVec2ByPoint(point0:Point, point1:Point):Vector2D{
			return new Vector2D(new VFactor(point0.x, point0.y, point1.x - point0.x, point1.y - point0.y));
		}

		/**
		 * exterior Perp product
		 * @param Number
		 * @return
		 * */

		static public function perpProduct(vector0:VFactor, vector1:VFactor):Number {
			return (vector0.vx * vector1.vy - vector0.vy * vector1.vx);
		}
		
		static public function getNormal(vfactor:VFactor):VFactor {
			return new VFactor(vfactor.x, vfactor.y, vfactor.vx / vfactor.length, vfactor.vy / vfactor.length);
		}

		

		/**
		 * x 방향 가속
		 * @return
		 * */
		public var ax:Number;
		/**
		 * y 방향 가속
		 * @return
		 * */
		public var ay:Number;
		
		
		/**
		 * bounciness
		 * @default 1.0
		 */
		public var bounciness:Number = 1;
		/**
		 * friction
		 * @default 1.0
		 */
		public var friction:Number = 1;
		
		private var _factor:VFactor;
		public function get factor():VFactor {
			_factor.x = this.x;
			_factor.y = this.y;
			_factor.vx = this.vx;
			_factor.vy = this.vy;
			return _factor;
		}

		private var _left:VFactor;
		private var _right:VFactor;
		private var _normal:VFactor;
		private var _p0:Point;
		private var _p1:Point;
		
		//private var _vx:Number;
		//private var _vy:Number;

		/**
		 * 글로벌 좌표의 벡터방향
		 * @return
		 * */
		public function get angle():Number{
			return Math.atan2(vy, vx);
		}
		
		public function clone():Vector2D {
			return new Vector2D(new VFactor(this.x, this.y, vx, vy));
		}
		/**
		 * 글로벌 좌표의 벡터방향(360도 환산)
		 * @return
		 * */
		public function get degree():Number {
			return angle * 180 / Math.PI;
		}

		/**
		 * intersection Point 를 구한다.
		 * @param v1 비교할 대상
		 * @return 평행하여 만나지 않을 경우 null
		 */
		public function getInterPoint(v1:Vector2D):Point {

			if(this.normal.x == v1.normal.x && this.normal.y == v1.normal.y) return null;
			if(this.normal.x == -v1.normal.x && this.normal.y == -v1.normal.y) return null;

			var v2:Vector2D = Vector2D.getVec2ByPoint(this.p0, v1.p0);
			var t:Number = Vector2D.perpProduct(v2.factor, v1.factor) / Vector2D.perpProduct(this.factor, v1.factor);

			return new Point(this.x + this.vx * t, this.y + this.vy * t);
		}

		/**
		 * 투영벡터 구한다능
		 * @param vector Vector2d형의 투영할 대상벡터
		 * */
		public function getProjectOn(vfactor:VFactor):VFactor{
			var dp:Number = Vector2D.getDotProduct(this.factor, vfactor);
			return new VFactor(this.x, this.y, dp / vfactor.length * (vfactor.vx / vfactor.length), dp  / vfactor.length * (vfactor.vy / vfactor.length));
		}
		
		/**
		 * 벡터의 속도를 나타냄
		 * @return VFactor
		 * */
		public function getVelocity():VFactor {
			return new VFactor(this.x, this.y, vx, vy);
		}
		
		/**
		 * 벡터와 직교하는 왼쪽 벡터
		 * @return
		 * */
		public function get left():VFactor {
			_left.x = this.x;
			_left.y = this.y;
			_left.vx = this.vy;
			_left.vy = this.vx * (-1); 
			return _left;
		}
		
		/**
		 * 벡터와 직교하는 오른쪽 벡터
		 * @return
		 * */
		public function get right():VFactor{
			
			_right.x = this.x;
			_right.y = this.y;
			_right.vx = this.vy * (-1);
			_right.vy = this.vx;	
			
			return _right;
		}

		/**
		 * 단위벡터
		 * @return
		 * */
		public function get normal():VFactor {
			_normal.x = this.x;
			_normal.y = this.y;
			_normal.vx = vx/length;
			_normal.vy = vy/length;
			return _normal;
		}

		/**
		 * 벡터의 시작점
		 * @return
		 * */

		public function get p0():Point{
			_p0.x = this.x;
			_p0.y = this.y;
			return _p0;
		}

		/**
		 * 벡터의 끝점
		 * @return
		 * */

		public function get p1():Point {
			_p1.x = this.x + vx;
			_p1.y = this.y + vy;
			return _p1;
		}
	}
}

