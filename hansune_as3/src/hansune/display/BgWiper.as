package hansune.display {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import hansune.Hansune;
	import hansune.motion.easing.Sine;
	import hansune.motion.easing.Strong;

	/**
	 * 이미지가 교체되었음.
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 파일 로드 오류
	 */	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * 이미지를 와이퍼처럼 모션을 주며 교체
	 * @author hanhyonsoo
	 */
	public class BgWiper extends Sprite {

		private var viewW:Number;
		private var viewH:Number;
		private var imgLoader:Loader;
		private var _isIng:Boolean;
		private var _loadedByte:Number = 0;
		private var _totalByte:Number = 0;
		
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		static public const UP:String = "up";
		static public const DOWN:String = "down";
		
		private var masking:GradientBg;
		private var direct:String = "";
		private var upRect:Rectangle;
		private var dnRect:Rectangle;
		private var rightRect:Rectangle;
		private var leftRect:Rectangle;
		private var finRect:Rectangle;
		private var trasitTime:Number;
		
		/**
		 * 이미지를 와이퍼처럼 모션을 주며 교체
		 * @param W
		 * @param H
		 */
		public function BgWiper(W:Number, H:Number):void {
			
			Hansune.copyright();
			viewW = W;
			viewH = H;
			_isIng = false;
			   
			upRect = new Rectangle(0, viewH, viewW, 0);
			dnRect = new Rectangle(0, 0, viewW, 0);
			rightRect = new Rectangle(0, 0, 0, viewH);
			leftRect = new Rectangle(viewW, 0, 0, viewH);
			finRect = new Rectangle(0, 0, viewW, viewH);
			
			masking = new GradientBg(leftRect, finRect);
			
		}

		/**
		 * 트랜지션 진행중인지 여부
		 * @return 
		 * 
		 */
		public function get isIng():Boolean
		{
			return _isIng;
		}

		/**
		 * 총 바이트수
		 * @return 
		 * 
		 */
		public function get totalByte():Number
		{
			return _totalByte;
		}

		/**
		 * 로드된 바이트수
		 * @return 
		 * 
		 */
		public function get loadedByte():Number
		{
			return _loadedByte;
		}

		/**
		 *  이미지 로드
		 * @param url 파일 경로
		 * @param trasitTime 변화 시간
		 * @param direct 방향
		 * 
		 */
		public function load(url:String, trasitTime:Number = 0.3, direct:String = "left"):void {
			if (!isIng) {
				_isIng = true;
				imgLoader = new Loader();
				var request:URLRequest = new URLRequest(url);
				imgLoader.load(request);
				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErr);
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imgView);
				imgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,Progress);
				this.trasitTime = trasitTime;
				this.direct = direct;
			}
		}
		
		private function ioErr(e:IOErrorEvent):void{
			trace(e.text);
			dispatchEvent(e.clone());
		}
		
		private function imgView(event:Event):void {
			var newImage:Bitmap = Bitmap(imgLoader.content);
			//var newMASK:GradientBg = new GradientBg(0,0,0,0,0,viewH,0,viewH,0,0,viewW,0,viewW,viewH,0,viewH);
			//newMASK.setGradient(GradientType.LINEAR,'0x000000','0x000000',1,1);
			switch(direct) {
				case UP:
					masking.resetToInitial(upRect);
					newImage.mask = masking;
					break;
				case DOWN :
					masking.resetToInitial(dnRect);
					newImage.mask = masking;
					break;
				case LEFT :
					masking.resetToInitial(leftRect);
					newImage.mask = masking;
					break;
				case RIGHT :
					masking.resetToInitial(rightRect);
					newImage.mask = masking;
					break;
			}
			
			this.addChild(newImage);
			this.addChild(masking);
			masking.draw(trasitTime, Sine.easeOut);
			masking.addEventListener(Event.COMPLETE,drawChk);
		}
		
		private function drawChk(e:Event):void {
			if(numChildren > 2) {
				var bm:Bitmap = getChildAt(0) as Bitmap;
				if(bm) {
					bm.bitmapData.dispose();
				}
				this.removeChildAt(0);
			}
			_isIng = false;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function Progress(e:ProgressEvent):void{
			_loadedByte = e.bytesLoaded;
			_totalByte = e.bytesTotal;
		}
		
		/**
		 * 이벤트 해제, 디스플레이 리스트 해제
		 * 
		 */
		public function release():void {
			var ln:int = numChildren;
			for (var i:int=0; i < ln; i++) {
				var bm:Bitmap = getChildAt(0) as Bitmap;
				if(bm) {
					bm.bitmapData.dispose();
				}
				removeChildAt(0);
			}
		}
		
	}
}