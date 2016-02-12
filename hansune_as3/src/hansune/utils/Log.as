package hansune.utils
{
	public class Log
	{
		public function Log()
		{
		}
		
		public static function d(tag:String, ...args):void {
			trace(tag, "-d-", args);
		}
		
		public static function e(tag:String, ...args):void {
			trace(tag, "-E-", args);
		}
		
		public static function i(tag:String, ...args):void {
			trace(tag, "-i-", args);
		}
	}
}