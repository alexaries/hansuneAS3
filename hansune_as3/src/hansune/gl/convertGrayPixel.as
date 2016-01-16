package hansune.gl
{
	/**
	 * 
	 * @param pixel16
	 * @return Y=0.3RED+0.59GREEN+0.11Blue
	 */
	public function convertGrayPixel(pixel16:uint):uint
	{
		var r:uint; 
		var g:uint; 
		var b:uint;
		r = (pixel16 & 0xff0000) >>> 16;
		g = (pixel16 & 0x00ff00) >>> 8;
		b = (pixel16 & 0x0000ff);
		
		return 0.3*r + 0.59*g + 0.11*b;
	}
}

