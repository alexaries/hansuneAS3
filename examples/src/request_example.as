package
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import hansune.net.Request;

	public class request_example extends Sprite
	{
		private var request:Request; 
		public function request_example()
		{
			
			Security.allowInsecureDomain("*.dosirak.com");
			Security.allowInsecureDomain("*.moazine.com");
			Security.allowDomain("*");
			request = new Request();
			//request.url = "http://www.dosirak.com/ollehCampus/MusicVideo/j_DNewMusicVideo.asp";
			request.url = "http://www.dosirak.com/ollehCampus/musicservice/GetStreammingKey.asp?uno=9643487&cid=80721285&sid=&pv=Y&mul=/MP/VIDEO/000/041/41786_800.wmv&NonStreamPrdt=Y&Cashtype=";
			//request.url = "http://www.dosirak.com/ollehCampus/musicservice/j_movstreaminglist.asp";
			
			//uno=9643487&cid=80721285&sid=&pv=Y&mul=/MP/VIDEO/000/041/41786_800.wmv&NonStreamPrdt=Y&Cashtype=
			var values:URLVariables = new URLVariables();
			values.uno = 9643487;
			values.cid = 80721285;
			values.sid = "";
			values.pv="Y";
			values.mul="/MP/VIDEO/000/041/41786_800.wmv";
			values.NonStreamPrdt="Y";
			values.Cashtype="";

			//values.streaminglist=80721285;
			//values.separator="ocampus";
			/*values.usepage="asp";
			values.pageno=1;
			values.pagesize=50;
			values.genrecode="ALL";
			values.lowcode="";
			values.sorttype="RDD";
			values.separator="ocampus";*/
			/*
			var us:URLStream = new URLStream();
			us.addEventListener(Event.COMPLETE, onComp);
			us.load(new URLRequest("http://www.dosirak.com/ollehCampus/musicservice/GetStreammingKey.asp?uno=9643487&cid=80721285&sid=&pv=Y&mul=/MP/VIDEO/000/041/41786_800.wmv&NonStreamPrdt=Y&Cashtype="));
			us.load(new URLRequest("http://www.dosirak.com/ollehCampus/musicservice/GetStreammingKey.asp?uno=9643487&cid=80721285&sid=&pv=Y&mul=/MP/VIDEO/000/041/41786_800.wmv&NonStreamPrdt=Y&Cashtype="));
	
			*/
			
			request.addEventListener(Event.COMPLETE, onComp);
			request.addEventListener(IOErrorEvent.IO_ERROR, onIo);
			request.send(values);
		}
		
		private function onComp(e:Event):void {
			trace("ok");
			//var us:URLStream = e.target as URLStream;
			//var str:String = us.readMultiByte(us.bytesAvailable, "ks_c_5601-1987");
			trace(request.data);
			//var obj:Object= JSON.decode(request.data);
			//trace(obj.RESULT.CATEGORY.NAME);
		}
		
		private function onIo(e:IOErrorEvent):void {
			
		}
	}
}