package hansune.utils
{
	public function sortFileNames(strings:Array):Array
	{
		return strings.sort(compare);
		
		var str1:String, str2:String;
		var pos1:int, pos2:int, len1:int, len2:int;
		
		function compare(s1:String, s2:String):int
		{
			str1 = s1;
			str2 = s2;
			len1 = str1.length;
			len2 = str2.length;
			pos1 = pos2 = 0;
			
			var result:int = 0;
			while (result == 0 && pos1 < len1 && pos2 < len2)
			{
				var ch1:String = str1.charAt(pos1);
				var ch2:String = str2.charAt(pos2);
				
				if (isNumeric(ch1))
				{
					result = isNumeric(ch2) ? compareNumbers() : -1;
				}
				else if (!isNumeric(ch1))
				{
					result = !isNumeric(ch2) ? compareOther(true) : 1;
				}
				else
				{
					result = isNumeric(ch2) ? 1
						: !isNumeric(ch2) ? -1
						: compareOther(false);
				}
				
				pos1++;
				pos2++;
			}
			
			return result == 0 ? len1 - len2 : result;
		}
		
		function compareNumbers():int
		{
			var end1:int = pos1 + 1;
			while (end1 < len1 && isNumeric(str1.charAt(end1)))
			{
				end1++;
			}
			var fullLen1:int = end1 - pos1;
			while (pos1 < end1 && str1.charAt(pos1) == '0')
			{
				pos1++;
			}
			
			var end2:int = pos2 + 1;
			while (end2 < len2 && isNumeric(str2.charAt(end2)))
			{
				end2++;
			}
			var fullLen2:int = end2 - pos2;
			while (pos2 < end2 && str2.charAt(pos2) == '0')
			{
				pos2++;
			}
			
			var delta:int = (end1 - pos1) - (end2 - pos2);
			if (delta != 0)
			{
				return delta;
			}
			
			while (pos1 < end1 && pos2 < end2)
			{
				delta = str1.charAt(pos1++).charCodeAt(0) - str2.charAt(pos2++).charCodeAt(0);
				if (delta != 0)
				{
					return delta;
				}
			}
			
			pos1--;
			pos2--; 
			
			return fullLen2 - fullLen1;
		}
		
		function compareOther(isLetters:Boolean):int
		{
			var ch1:String = str1.charAt(pos1);
			var ch2:String = str2.charAt(pos2);
			
			if (ch1 == ch2)
			{
				return 0;
			}
			
			if (isLetters)
			{
				ch1 = ch1.toUpperCase();
				ch2 = ch2.toUpperCase();
				if (ch1 != ch2)
				{
					ch1 = ch1.toLowerCase();
					ch2 = ch2.toLowerCase();
				}
			}
			
			return ch1.charCodeAt(0) - ch2.charCodeAt(0);
		}
		
		function isNumeric(sourceString:String):Boolean {
			if (sourceString == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(sourceString);
		}
	}
}