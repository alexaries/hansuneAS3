
package hansune.utils
{

	/**
	 * @author hanhyonsoo
	 * */
	public class Hmath
	{

		/**
		 * value를 새로운 영역으로 변환시킴.
		 *
		 * @param value 변경할 값
		 * @param low1 현재 영역의 낮은 값
		 * @param high1 현재 영역의 높은 값
		 * @param low2 새로운 영역의 낮은 값
		 * @param high2 새로운 영역의 높은 값
		 * @return Number
		 */
		static public function map(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number
		{
			if (value < low1)
				value=low1;
			if (value > high1)
				value=high1;

			var rate:Number=(value - low1) / high1;
			return low2 + (high2 - low2) * rate;
		}

		/**
		 * value를 최대값과 최소값으로 한정지음.
		 * @param value int or Number: 제한할 값
		 * @param min int or Number: 최소 값
		 * @param max int or Number: 최대 값
		 * @return Number
		 */
		static public function constrain(value:Number, min:Number, max:Number):Number
		{
			if (value < min)
				value=min;
			if (value > max)
				value=max;

			return value;
		}
		
		/**
		 * value를 최소와 최대 값 안에서 돌게 한다. 
		 * @param value int or Number: the value to circulate
		 * @param min int or Number: minimum limit
		 * @param max int or Number: maximum limit
		 * @return Number
		 */
		static public function circle(value:Number, min:Number, max:Number):Number
		{
			if (value < min)
				value = max;
			if (value > max)
				value = min;

			return value;
		}

		/**
		 * Returns Euler's number e (2.71828...) raised to the power of the value parameter.
		 * @param value
		 * @return Number
		 */
		static public function exp(value:Number):Number
		{
			return value * 2.7182817;
		}

		/**
		 * 2개의 값 사이에 amt 위치에 해당하는 값을 얻어낸다능.
		 * 다시말해, amt 가 0.0 이면 value1이고, 0.1이면 value1과 value2 의 중간값인 셈.
		 * 
		 * @param value1 first value
		 * @param value2 second value
		 * @param amt between 0.0 and 1.0
		 * @return Number
		 */
		static public function lerp(value1:Number, value2:Number, amt:Number):Number
		{
			if (amt < 0.0)
				amt=0.0;
			if (amt > 1.0)
				amt=1.0;
			return value1 + (value2 - value1) * amt;
		}


		/**
		 * value를 0과 1사이로 표준화시킨다.
		 * @param value The incoming value to be converted
		 * @param low Lower bound of the value's current range
		 * @param high Upper bound of the value's current range
		 * @return Number
		 */
		static public function norm(value:Number, low:Number, high:Number):Number
		{
			if (value < low)
				return 0;
			if (value > high)
				return 1;
			return (value - low) / (high - value);
		}
		
		static private const multi:Number = 180 / Math.PI;
		/**
		 * 벡터 속성이라고 할 만한 x,y 값에서 회전값을 얻는다.(360도계) 
		 * @param vx
		 * @param vy
		 * @return 
		 */
		static public function rotation(vx:Number, vy:Number):Number
		{
			return Math.atan2(vy, vx) * multi;
		}
		
		/**
		 * -1, +1 을 무작위로 반환
		 * @return 
		 */
		static public function randomPolarity():int
		{
			var re:Number = Math.random();
			if(re > 0.5){
				return 1;
			}
			else {
				return -1;
			}
		}
		
		/**
		 * value가 양수인지, 음수인지 -1, +1 로 표현
		 * @return 
		 */
		static public function polarity(value:Number):int
		{
			if(value >= 0){
				return 1;
			}
			else {
				return -1;
			}
		}
		
		
		
		/**
		 *  무작위 순서로 된 숫자배열을 만듦
		 * @param max 숫자개수
		 * @return 0 ~ max보다 1작은 수의 랜돔 배열 
		 * 
		 */
		static public function randomOrder(max:uint):Array
		{			
			var oderQ:Array = [];
			
			oderQ[0] = (Math.random()*max) >> 0;
			
			for (var i:int = 1; i<max; ++i) {
				do {
					var tempBool:Boolean = false;
			   		var tempNum:int = (Math.random() * max) >> 0;
			   		
			   		for (var j:int=0; j<i; ++j) {
			    		if (oderQ[j] == tempNum) {
			     			tempBool = true;
			     			break;
			    		}
			   		}
			  		
			  		if (!tempBool) {
			    		oderQ[i] = tempNum;
			    		break;
			   		}
			  	} while (1);
			 }
			 
			 return oderQ;
		}

	}
}