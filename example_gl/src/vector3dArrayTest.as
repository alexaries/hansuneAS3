package
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import hansune.gl.Vector3DArray;
	
	public class vector3dArrayTest extends Sprite
	{
		public function vector3dArrayTest()
		{
			
			var ar:Vector3DArray;
			ar = new Vector3DArray(2);
			trace(ar);
			ar.push(new Vector3D(0,0,0,0));
			trace(ar);
		}

	}
}