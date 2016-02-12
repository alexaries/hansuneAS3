package hansune.gl
{
	public function randomColor(alphaRandom:Boolean = false):uint
	{
		var alpha:uint = (alphaRandom)? int(Math.random() * 256) : 255;
		var red:uint = int(Math.random() * 256);
		var green:uint = int(Math.random() * 256);
		var blue:uint = int(Math.random() * 256);
		
		return (alpha << 24) | (red << 16) | (green << 8) | (blue);
	}
}