package hansune.data
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author hanhyonsoo
	 */
	public class EncryptedLocalStore 
	{
		static private var dic:Dictionary;
		
		public function EncryptedLocalStore() 
		{
			
		}
		
		static public function getItem(keyName:String):ByteArray {
			if (dic == null)  return null;
			return dic[keyName];
		}
		
		static public function setItem(keyName:String, salt:ByteArray):void {
			if (dic == null) dic = new Dictionary();
			dic[keyName] = salt;
		}
		
	}
	
}