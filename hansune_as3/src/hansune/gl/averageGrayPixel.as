//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

/**
 * References
 * http://www.compuphase.com/graphic/scale3.htm
 * */
package hansune.gl
{
	/**
	 * 
	 * @param pixelA
	 * @param pixelB
	 * @return average value
	 */
	public function averageGrayPixel(pixelA:uint, pixelB:uint):uint {
		var a:uint = (pixelA + pixelB) >> 1;
		return a;
	}
}