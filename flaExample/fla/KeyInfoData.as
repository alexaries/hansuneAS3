package fla
{
	import hansune.ui.keyMeta.*;
	/**
	 * 키 버튼들 정보입력.
	 * @author hansoo
	 */
	public class KeyInfoData 
	{
		private var _info:Array;
		public function KeyInfoData() 
		{
			_info = new Array(31);
			
			_info[0] = new KeyInfo(KeyType.NORMAL_KEY, "ㅂ", "q", "1");
			_info[1] = new KeyInfo(KeyType.NORMAL_KEY, "ㅈ", "w", "2");
			_info[2] = new KeyInfo(KeyType.NORMAL_KEY, "ㄷ", "e", "3");
			_info[3] = new KeyInfo(KeyType.NORMAL_KEY, "ㄱ", "r", "4");
			_info[4] = new KeyInfo(KeyType.NORMAL_KEY, "ㅅ", "t", "5");
			_info[5] = new KeyInfo(KeyType.NORMAL_KEY, "ㅛ", "y", "6");
			_info[6] = new KeyInfo(KeyType.NORMAL_KEY, "ㅕ", "u", "7");
			_info[7] = new KeyInfo(KeyType.NORMAL_KEY, "ㅑ", "i", "8");
			_info[8] = new KeyInfo(KeyType.NORMAL_KEY, "ㅐ", "o", "9");
			_info[9] = new KeyInfo(KeyType.NORMAL_KEY, "ㅔ", "p", "0");
			
			_info[10] = new KeyInfo(KeyType.NORMAL_KEY, "ㅁ", "a", "~");
			_info[11] = new KeyInfo(KeyType.NORMAL_KEY, "ㄴ", "s", "!");
			_info[12] = new KeyInfo(KeyType.NORMAL_KEY, "ㅇ", "d", "@");
			_info[13] = new KeyInfo(KeyType.NORMAL_KEY, "ㄹ", "f", "?");
			_info[14] = new KeyInfo(KeyType.NORMAL_KEY, "ㅎ", "g", "^");
			_info[15] = new KeyInfo(KeyType.NORMAL_KEY, "ㅗ", "h", "*");
			_info[16] = new KeyInfo(KeyType.NORMAL_KEY, "ㅓ", "j", "(");
			_info[17] = new KeyInfo(KeyType.NORMAL_KEY, "ㅏ", "k", ")");
			_info[18] = new KeyInfo(KeyType.NORMAL_KEY, "ㅣ", "l", "+");
			
			_info[19] = new KeyInfo(KeyType.NORMAL_KEY, "ㅋ", "z", "_");
			_info[20] = new KeyInfo(KeyType.NORMAL_KEY, "ㅌ", "x", "-");
			_info[21] = new KeyInfo(KeyType.NORMAL_KEY, "ㅊ", "c", ".");
			_info[22] = new KeyInfo(KeyType.NORMAL_KEY, "ㅍ", "v", "/");
			_info[23] = new KeyInfo(KeyType.NORMAL_KEY, "ㅠ", "b", ":");
			_info[24] = new KeyInfo(KeyType.NORMAL_KEY, "ㅜ", "n", "&");
			_info[25] = new KeyInfo(KeyType.NORMAL_KEY, "ㅡ", "m", "♥");
			_info[26] = new KeyInfo(KeyType.FUNC_KEY, FuncKey.SHIFT);
			_info[27] = new KeyInfo(KeyType.FUNC_KEY, FuncKey.SPECIAL);
			_info[28] = new KeyInfo(KeyType.FUNC_KEY, FuncKey.SPACE);
			_info[29] = new KeyInfo(KeyType.FUNC_KEY, FuncKey.KOR_ENG);
			_info[30] = new KeyInfo(KeyType.FUNC_KEY, FuncKey.BACK_SPACE);
			
		}
		
		public function getInfo(index:uint):KeyInfo {
			return _info[index];
		}
	}
	
}