package
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	public class getClassName extends Sprite
	{
		
		private var box:Box = new Box();
		public function getClassName()
		{
			super();
			trace(getQualifiedClassName(box));
		}
		
	}
}
	import flash.display.Sprite;
	


class Box extends Sprite {
	
}