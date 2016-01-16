package hansune.text
{

	/**
	* 	String Utilities class by Ryan Matsikas, Feb 10 2006
	*
	*	Visit www.gskinner.com for documentation, updates and more free code.
	* 	You may distribute this code freely, as long as this comment block remains intact.
	 * 
	 *  수정 ㅣ hanhyonsoo / blog.hansune.com
	 * 	메소드 명, 주석 수정, 일부 코드 수정 | 090706
	*/

	public class StringUtils {

		/**
		*	Returns everything after the first occurrence of the provided character in the string.
		*
		*	@param sourceString The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function allAfterFirstOccur(sourceString:String, p_char:String):String {
			if (sourceString == null) { return ''; }
			var idx:int = sourceString.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return sourceString.substr(idx);
		}

		/**
		*	Returns everything after the last occurence of the provided character in sourceString.
		*
		*	@param sourceString The string.
		*
		*	@param p_char The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function allAfterLastOccur(sourceString:String, p_char:String):String {
			if (sourceString == null) { return ''; }
			var idx:int = sourceString.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return sourceString.substr(idx);
		}

		/**
		*	Returns everything before the first occurrence of the provided character in the string.
		*
		*	@param sourceString The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function allBeforeFirstOccur(sourceString:String, p_char:String):String {
			if (sourceString == null) { return ''; }
			var idx:int = sourceString.indexOf(p_char);
        	if (idx == -1) { return ''; }
        	return sourceString.substr(0, idx);
		}

		/**
		*	Returns everything before the last occurrence of the provided character in the string.
		*
		*	@param sourceString The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function allBeforeLastOccur(sourceString:String, p_char:String):String {
			if (sourceString == null) { return ''; }
			var idx:int = sourceString.lastIndexOf(p_char);
        	if (idx == -1) { return ''; }
        	return sourceString.substr(0, idx);
		}

		/**
		*	Returns everything after the first occurance of p_start and before
		*	the first occurrence of p_end in sourceString.
		*
		*	@param sourceString The string.
		*
		*	@param p_start The character or sub-string to use as the start index.
		*
		*	@param p_end The character or sub-string to use as the end index.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function between(sourceString:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (sourceString == null) { return str; }
			var startIdx:int = sourceString.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = sourceString.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = sourceString.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}

		/**
		*	Description, Utility method that intelligently breaks up your string,
		*	allowing you to create blocks of readable text.
		*	This method returns you the closest possible match to the p_delim paramater,
		*	while keeping the text length within the p_len paramter.
		*	If a match can't be found in your specified length an  '...' is added to that block,
		*	and the blocking continues untill all the text is broken apart.
		*
		*	@param sourceString The string to break up.
		*
		*	@param blockLength Maximum length of each block of text.
		*
		*	@param delimiter delimiter to end text blocks on, default = '.'
		*
		*	@returns Array
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function block(sourceString:String, blockLength:uint, delimiter:String = "."):Array {
			var arr:Array = new Array();
			if (sourceString == null || !contains(sourceString, delimiter)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = sourceString.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(delimiter)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = sourceString.substr(chrIndex, blockLength);
				if (!contains(subString, delimiter)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		*	Capitallizes the first word in a string or all words..
		*
		*	@param sourceString The string.
		*
		*	@param onlyFirst (optional) Boolean value indicating if we should
		*	capitalize all words or only the first.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function capitalize(sourceString:String, onlyFirst:Boolean = true, ...arg):String {
			var str:String = removeWhitespaceLeft(sourceString);
			if (!onlyFirst) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}

		/**
		*	Determines whether the specified string contains any instances of p_char.
		*
		*	@param sourceString The string.
		*
		*	@param p_char The character or sub-string we are looking for.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function contains(sourceString:String, p_char:String):Boolean {
			if (sourceString == null) { return false; }
			return sourceString.indexOf(p_char) != -1;
		}

		/**
		*	Determines the number of times a charactor or sub-string appears within the string.
		*
		*	@param sourceString The string.
		*
		*	@param p_char The character or sub-string to count.
		*
		*	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		*	search is case sensitive.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function countOf(sourceString:String, p_char:String, caseSensitive:Boolean = true):uint {
			if (sourceString == null) { return 0; }
			var char:String = escapePattern(p_char);
			var flags:String = (!caseSensitive) ? 'ig' : 'g';
			return sourceString.match(new RegExp(char, flags)).length;
		}

		/**
		*	The method - differanceOf is a measure of the similarity between two strings,
		*	The distance is the number of deletions, insertions, or substitutions required to
		*	transform sourceString into compareString.
		*
		*	@param sourceString The source string.
		*
		*	@param compareString The target string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function differenceOf(sourceString:String, compareString:String):uint {
			var i:uint;

			if (sourceString == null) { sourceString = ''; }
			if (compareString == null) { compareString = ''; }

			if (sourceString == compareString) { return 0; }

			var d:Array = new Array();
			var cost:uint;
			var n:uint = sourceString.length;
			var m:uint = compareString.length;
			var j:uint;

			if (n == 0) { return m; }
			if (m == 0) { return n; }

			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }

			for (i=1; i<=n; i++) {

				var s_i:String = sourceString.charAt(i-1);
				for (j=1; j<=m; j++) {

					var t_j:String = compareString.charAt(j-1);
					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }

					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}

		/**
		*	Determines whether the specified string ends with the specified suffix.
		*
		*	@param sourceString The string that the suffic will be checked against.
		*
		*	@param p_end The suffix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isEndWith(sourceString:String, p_end:String):Boolean {
			return sourceString.lastIndexOf(p_end) == sourceString.length - p_end.length;
		}

		/**
		*	Determines whether the specified string contains text.
		*	스트링에 문자가 포함되어 있는지 판단. 
		*
		*	@param sourceString The string to check.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function hasText(sourceString:String):Boolean {
			var str:String = removeExtraWhitespace(sourceString);
			return !!str.length;
		}

		/**
		*	해당 스트링에 문자가 있는지 여부, 공백도 문자로 판단한다.
		*	@param sourceString The string to check
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isEmpty(sourceString:String):Boolean {
			if (sourceString == null) { return true; }
			return !sourceString.length;
		}

		/**
		*	Determines whether the specified string is numeric.
		*	숫자로 이루어진 스트링인지 판단. / 공백은 문자
		*	@param sourceString The string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isNumeric(sourceString:String):Boolean {
			if (sourceString == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(sourceString);
		}

		/**
		* Pads sourceString with specified character to a specified length from the left.
		* 주어진 스트링의 길이를 length로 맞춘다. length를 맞추기 위해 padChar를 사용함.
		*	@param sourceString String to pad
		*
		*	@param padChar Character for pad.
		*
		*	@param length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padLeft(sourceString:String, padChar:String, length:uint):String {
			var s:String = sourceString;
			while (s.length < length) { s = padChar + s; }
			return s;
		}

		/**
		* Pads sourceString with specified character to a specified length from the right.
		*
		*	@param sourceString String to pad
		*
		*	@param padChar Character for pad.
		*
		*	@param length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padRight(sourceString:String, padChar:String, length:uint):String {
			var s:String = sourceString;
			while (s.length < length) { s += padChar; }
			return s;
		}

		/**
		*	Properly cases' the string in "sentence format".
		*
		*	@param sourceString The string to check
		*
		*	@returns String.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function properCase(sourceString:String):String {
			if (sourceString == null) { return ''; }
			var str:String = sourceString.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		*	Escapes all of the characters in a string to create a friendly "quotable" sting
		*
		*	@param sourceString The string that will be checked for instances of remove
		*	string
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function quote(sourceString:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ sourceString.replace(regx, _quote) +'"';
		}

		/**
		*	Removes all instances of the remove string in the input string.
		*
		*	@param sourceString The string that will be checked for instances of remove
		*	string
		*
		*	@param p_remove The string that will be removed from the input string.
		*
		*	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function remove(sourceString:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (sourceString == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return sourceString.replace(new RegExp(rem, flags), '');
		}

		/**
		*	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		*	specified string.
		*
		*	@param sourceString The String whose extraneous whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeExtraWhitespace(sourceString:String):String {
			if (sourceString == null) { return ''; }
			var str:String = removeWhitespaceSide(sourceString);
			return str.replace(/\s+/g, ' ');
		}

		/**
		*	Returns the specified string in reverse character order.
		*
		*	@param sourceString The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverse(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.split('').reverse().join('');
		}

		/**
		*	Returns the specified string in reverse word order.
		*
		*	@param sourceString The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverseWords(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.split(/\s+/).reverse().join('');
		}

		/**
		*	Determines the percentage of similiarity, based on differenceOf
		*
		*	@param sourceString The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns Number
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function similarity(sourceString:String, p_target:String):Number {
			var ed:uint = differenceOf(sourceString, p_target);
			var maxLen:uint = Math.max(sourceString.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}

		/**
		*	Remove's all < and > based tags from a string
		*
		*	@param sourceString The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function stripTags(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		*	Swaps the casing of a string.
		*
		*	@param sourceString The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function swapCase(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.replace(/(\w)/, _swapCase);
		}

		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		*
		*	@param sourceString The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeWhitespaceSide(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.replace(/^\s+|\s+$/g, '');
		}

		/**
		*	Removes whitespace from the front (left-side) of the specified string.
		*
		*	@param sourceString The String whose beginning whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeWhitespaceLeft(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.replace(/^\s+/, '');
		}

		/**
		*	Removes whitespace from the end (right-side) of the specified string.
		*
		*	@param sourceString The String whose ending whitespace will be removed.
		*
		*	@returns String	.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeWhitespaceRight(sourceString:String):String {
			if (sourceString == null) { return ''; }
			return sourceString.replace(/\s+$/, '');
		}

		/**
		*	Determins the number of words in a string.
		*
		*	@param sourceString The string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function wordCount(sourceString:String):uint {
			if (sourceString == null) { return 0; }
			return sourceString.match(/\b\w+\b/g).length;
		}

		/**
		*	Returns a string truncated to a specified length with optional suffix
		*
		*	@param sourceString The string.
		*
		*	@param p_len The length the string should be shortend to
		*
		*	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function truncate(sourceString:String, p_len:uint, p_suffix:String = "..."):String {
			if (sourceString == null) { return ''; }
			p_len -= p_suffix.length;
			var trunc:String = sourceString;
			var reg:RegExp = new RegExp(/[^\s]/);
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (reg.test(sourceString.charAt(p_len))) {
					trunc = removeWhitespaceRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}
		
		/**
		 * 이메일 형식인지 여부
		 * @param sourceString
		 * @return 
		 * @langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function availableEmail(sourceString:String):Boolean
		{
			if(sourceString == null) {return false;}
			if(hasText(sourceString) == false) {return false;}
			
			var myregexp:RegExp = new RegExp('^[A-Za-z0-9+_.-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,6}\\b');
			//"[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+"
			
			if (!myregexp.test(sourceString))
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}

		private static function _quote(sourceString:String, ...args):String {
			switch (sourceString) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ...args):String {
			//trace('cap latter ',p_char)
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}

	}
}