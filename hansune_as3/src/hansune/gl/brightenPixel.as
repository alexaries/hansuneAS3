package hansune.gl
{
	public function brightenPixel(c:uint, e:Number):uint
	{
		var r:uint = c >> 16 & 0xFF;
		var g:uint = c >> 8 & 0xFF;
		var b:uint = c & 0xFF;
		
		// Red
        r += uint(e * 255);
        if (r >255)
        {
            r = 255;
        }
        if (r <0)
        {
            r = 0;
        }

        // Green
        g += uint(e * 255);
        if (g>255)
        {
            g = 255;
        }
        if (g<0)
        {
            g = 0;
        }

        // Blue
        b += uint(e * 255);
        if (b >255)
        {
            b = 255;
        }
        if (b<0)
        {
            b = 0;
        }
        
		
		var color2:uint = (r << 16) | (g << 8) | (b);
		return color2;
	}

}