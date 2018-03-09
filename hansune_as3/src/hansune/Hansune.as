//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/HansuneAS3
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

/**
 * 
 * TODO List
 * 
 * ## 미비한 것
 * vision package - 기본적인 카메라 센싱 모듈 작성
 * Vec2, VFactor - example 작성 
 * 
 * ## 발전시킬 것
 * GLBitmap class - 이해도를 높일 것, 속도 개선, 활용예제 작성
 * 
 * */

package hansune
{
	public class Hansune
	{
		public static const AUTHOR:String = "han hyon soo";
		public static const HOME:String = "blog.hansoolabs.com";
		public static const VERSION:String = "1.41";
		public static const encoding:String = "utf-8";
		
		private static var ins:Hansune;
		private static var used:Boolean = false;
		public static function copyright():void {
			if(used) return;
			used = true;
			trace(ver());
		}
		public static function get instance():Hansune {
			if(Hansune.ins == null){
				Hansune.ins = new Hansune(new Single());
			}
			
			return Hansune.ins;
		}
		
		public function Hansune(single:Single):void {}
		
        public static function ver():String{
			var re:String =
				"* hansune AS3 lib : ver- " + VERSION + "\n" 
				+ "* homepage- " + HOME + " : maker- " + AUTHOR + "\n";
			
			return re;
		}
	}
}

internal class Single{}