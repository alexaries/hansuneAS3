package
{
	import flash.display.Sprite;
	
	import hansune.events.XLibraryEvent;
	import hansune.text.StringUtils;
	import hansune.text.XLibrary;
	import hansune.utils.sortFileNames;
	

	public class stringUtilsEx extends Sprite
	{
		private var xLib:XLibrary;
		public function stringUtilsEx()
		{
			/*
			var ss:String = "you may distribute this code freely, as long as this comment block remains intact."
			trace(StringUtils.allAfterFirstOccur(ss,"may"));
			trace(StringUtils.block(ss,30, " "));
			trace(StringUtils.capitalize(ss, false));
			trace(StringUtils.countOf(ss, "as"));
			trace(StringUtils.differenceOf(ss,"you may distribute this code freely, as long as this comment block remains"));
			trace(StringUtils.isNumeric("12"));
			trace(StringUtils.padLeft(ss,"12", 100));
			trace(StringUtils.properCase(ss));
			trace(StringUtils.quote(ss));
			
			trace(HangleUnicodeComposer.getString3Syllables("ㄱ","ㅣ","ㄹ"));
			*/
			
			xLib = new XLibrary();
			xLib.addEventListener(XLibraryEvent.LOAD_OK, onLoad);
			xLib.addEventListener(XLibraryEvent.NOT_FIND, onXNotFound);
			xLib.addEventListener(XLibraryEvent.X, onXFound);
			xLib.loadXTextFile("../data/badText.txt");
		}
		
		private function onLoad(e:XLibraryEvent):void {
			xLib.search("즐거운생각");
		}
		
		private function onXNotFound(e:XLibraryEvent):void {
			
		}
		
		private function onXFound(e:XLibraryEvent):void {
			trace("-", e.text);
		}
	}
}