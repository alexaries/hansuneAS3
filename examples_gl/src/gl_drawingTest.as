package
{
	import flash.display.Sprite;
	
	import hansune.gl.HBitmap;

	public class gl_drawingTest extends Sprite
	{
		public function gl_drawingTest()
		{
			super();
			var gl:HBitmap = new HBitmap(400,500);
			addChild(gl);
			
			gl.circle(100,100,40);
		}
		
	}
}