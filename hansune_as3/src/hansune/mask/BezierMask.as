package hansune.mask
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import hansune.Hansune;
	import hansune.ui.TestButton;
	import hansune.utils.alert;
	
	/**
	 * generate mask shape arranged with handler for air app.
	 * @author hansoo
	 */
	public class BezierMask extends Sprite
	{
		/**
		 * BezierMask constructor
		 * @param maskStyle choice shape style within BezierMaskStyle
		 */
		public function BezierMask(maskStyle:String = "rect")
		{
			super();
			style = maskStyle;
			Hansune.copyright();
		}
		
		/**
		 * shape to using for mask
		 * @default null
		 */
		public var bezierMask:AbsBezierMask;
				
		private var _disObj:DisplayObject;
		private var _infoFile:String = "data/maskinfo.bmi";
		private var _style:String = "rect";
		private var fitInitBt:TestButton;
		private var fitRectBt:TestButton;
		private var saveBt:TestButton;
		private var plusBt:TestButton;
		private var minusBt:TestButton;
		private var txt:String;
		
		/**
		 * return mask area by format Rectangle
		 * @return Rectangle
		 */
		public function getMaskRectangle():Rectangle
		{
			return bezierMask.maskShape.getRect(bezierMask);
		}
		
		/**
		 * hide handler
		 */
		public function hideHandle():void{
			if(fitRectBt == null) return;
			if(contains(fitRectBt)) removeChild(fitRectBt);
			if(contains(fitInitBt)) removeChild(fitInitBt);
			if(contains(plusBt)) removeChild(plusBt);
			if(contains(minusBt)) removeChild(minusBt);
			if(contains(saveBt)) removeChild(saveBt);

			fitRectBt.removeEventListener(MouseEvent.CLICK, onFitClick);
			fitInitBt.removeEventListener(MouseEvent.CLICK, onInitClick);
			saveBt.removeEventListener(MouseEvent.CLICK, onSaveClick);
			plusBt.removeEventListener(MouseEvent.CLICK, onPlusClick);
			minusBt.removeEventListener(MouseEvent.CLICK, onMinusClick);
			
			fitRectBt = null;
			fitInitBt = null;
			plusBt = null;
			minusBt = null;
			saveBt = null;
			
			bezierMask.hideHandle();
			_disObj.mask = this;
		}
		
		/**
		 * view handler
		 */
		public function viewHandle():void
		{
			if(_disObj == null) throw Error("setMask need");
			_disObj.mask = null;

			bezierMask.viewHandle();

			if(fitRectBt ==null) fitRectBt = new TestButton("fit to Rectangle");
			fitRectBt.x = 100;
			fitRectBt.y = 50;
			addChild(fitRectBt);

			if(fitInitBt ==null) fitInitBt = new TestButton("fit to Initial shape");
			fitInitBt.x = 100;
			fitInitBt.y = 75;
			addChild(fitInitBt);
			
			if(plusBt == null) plusBt = new TestButton("round + ");
			plusBt.x = 100;
			plusBt.y = 100;
			addChild(plusBt);
			
			if(minusBt == null) minusBt = new TestButton("round - ");
			minusBt.x = 140;
			minusBt.y = 100;
			addChild(minusBt);
			
			if(saveBt == null) saveBt = new TestButton("save & exit");
			saveBt.x = 100;
			saveBt.y = 130;
			addChild(saveBt);

			fitRectBt.addEventListener(MouseEvent.CLICK, onFitClick);
			fitInitBt.addEventListener(MouseEvent.CLICK, onInitClick);
			plusBt.addEventListener(MouseEvent.CLICK, onPlusClick);
			minusBt.addEventListener(MouseEvent.CLICK, onMinusClick);
			saveBt.addEventListener(MouseEvent.CLICK, onSaveClick);

		}

		
		/**
		 * bezier information file
		 * @return 
		 */
		public function get infoFile():String
		{
			return _infoFile;
		}
		
		/**
		 * DisplayObject to be masked
		 * @param disObjForMask
		 */
		public function setMask(disObjForMask:DisplayObject):void
		{
			disObjForMask.mask = this;
			_disObj = disObjForMask;
		}
		/**
		 * BezierMaskStyle
		 * @return BezierMaskStyle
		 */
		public function get style():String{
			return bezierMask.info.style;
		}
		
		/**
		 * BezierMaskStyle
		 * @param value BezierMaskStyle
		 */
		public function set style(value:String):void
		{
			if(bezierMask != null && contains(bezierMask)) removeChild(bezierMask);
			if(value == BezierMaskStyle.CIRCLE || value == BezierMaskStyle.RECTANGLE){
				_style = value;
				switch(_style){
					case BezierMaskStyle.CIRCLE:	
						bezierMask = new BezierCircle();
						break;
					
					case BezierMaskStyle.RECTANGLE :
						bezierMask = new BezierRectangle();
						break;
				}
				
				addChild(bezierMask);
			}
		}
		
		
		/**
		 * update mask by bmi file
		 * @param url
		 */
		public function updateByFile(url:String):void {
			_infoFile = url;
			
			var urlRequest:URLRequest = new URLRequest(_infoFile);
			var ldr:URLLoader = new URLLoader();
			ldr.dataFormat = URLLoaderDataFormat.TEXT;
			ldr.addEventListener(Event.COMPLETE, onInfoFile);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, _infoioErr);
			ldr.load(urlRequest);
		}

		
		
		
		//마스크 설정파일이 없을 경우 기본 모드로 시작
		private function _infoioErr(e:IOErrorEvent):void{
			
			bezierMask.fitToInfo(bezierMask.defaultInfo);
			setTimeout(delayIoErr, 1000);

		}
		
		//
		private function delayIoErr():void {
			alert.x = stage.stageWidth / 2;
			alert.y = stage.stageHeight / 2;
			alert.show(stage, "it can't setting file - " + _infoFile);
		}
		
		
		//마스크 조정 시작
		private function launchMaskSetup(e:Event):void{
			bezierMask.viewHandle();
		}
		
		private function onFitClick(e:MouseEvent):void{
			bezierMask.fitToRect();
		}
		
		
		private function onInfoFile(e:Event):void{
			
			var loadTxt:String = e.target.data;
			var expression:RegExp=/[\n\r\f]/g;
			var strArray:Array = loadTxt.split(expression);
			var len:int = strArray.length;
			var varArray:Array;
			var data:Array = [];
			
			for(var i:int = 0; i < len; ++i){

				if(strArray[i].charAt(0) != " " && strArray[i].charAt(0) != "/"){
					varArray = String(strArray[i]).split(" ");
					data.push({name:varArray[0], value:varArray[1]});
				}
			}
			
			bezierMask.updateByData(data);	
		}

		private function onInitClick(e:MouseEvent):void{
			bezierMask.fitToInitSize();
		}

		private function onSaveClick(e:MouseEvent):void{
			saveToFile();
		}
		private function onPlusClick(e:MouseEvent):void {
			if(_style != BezierMaskStyle.RECTANGLE) return;
			bezierMask.round = Math.min(bezierMask.round + 1, 200); 
		}
		private function onMinusClick(e:MouseEvent):void {
			if(_style != BezierMaskStyle.RECTANGLE) return;
			bezierMask.round = Math.max(bezierMask.round - 1, 0);
		}
		
		private function onSaveFile(e:Event):void{
			var stringToSave:String = bezierMask.getSaveString();
			trace(stringToSave);
			var file:File = e.target as File;
			file.canonicalize();

			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(stringToSave, "ks_c_5601-1987");
			stream.close();

			hideHandle();			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//저장 멘트
		private function saveComp(e:Event):void
		{
			alert.show(stage, "save info.txt complete");
		}
		
		private function saveToFile():void{
			
			var file:File = File.applicationDirectory.resolvePath(_infoFile);
			file.browseForSave("select a file for bezierMask info data(bmi).");
			file.addEventListener(Event.SELECT, onSaveFile);
			/*
			var stringToSave:String = bezierMask.getSaveString();
			trace(stringToSave);
			//var file:File = e.target as File;
			var file:File = File.applicationDirectory.resolvePath(_infoFile);
			file.canonicalize();

			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.COMPLETE, onSaveFile);
			stream.open(file, FileMode.WRITE);
			*/
		}
	}
}

