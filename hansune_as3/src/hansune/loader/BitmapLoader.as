package hansune.loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import hansune.Hansune;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class BitmapLoader extends EventDispatcher
	{
		private var _bitmap:Bitmap;
		private var _isLoad:Boolean = false;
		public function get bitmap():Bitmap {
			if(_isLoad){
				return _bitmap;
			} else{
				return null;
			}
		}
		
		public function get width():Number {
			var result:Number;
			if (_isLoad) {
				result  = _bitmap.width;
			} else {
				result = 0;
			}
			
			return result;
		}
		
		public function get height():Number {
			var result:Number;
			if (_isLoad) {
				result  = _bitmap.height;
			} else {
				result = 0;
			}
			
			return result;
		}
		
		public function BitmapLoader(target:IEventDispatcher=null)
		{
			Hansune.copyright();
			super(target);
		}
		
		public function load(file:String):void{
			var request:URLRequest = new URLRequest(file);
			var ldr:Loader = new Loader();
			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoad);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _err);
			_isLoad = false;
			try{
				ldr.load(request);
			} catch (err:Error){
				trace("unable to load url");
			}
		}
		
		private function _onLoad(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE, _onLoad);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, _err);
			
			_bitmap = Bitmap(e.target.loader.content);
			_isLoad = true;
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		private function _err(e:IOErrorEvent):void{
			trace(e.text);
		}
		
		public function dispose():void {
			_bitmap.bitmapData.dispose();
		}
		
	}
}