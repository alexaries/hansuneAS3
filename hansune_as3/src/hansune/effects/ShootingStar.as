/**
 *
 * TODO 
 * 속도 개선
 * GPU 대응 API 작성 
 */

package hansune.effects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import hansune.Hansune;
	
	/**
	 * 모션이 끝났을 때 발생 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 간단한 파티클 효과 ShootingStar
	 * @author hyonsoohan
	 * 
	 */
	public class ShootingStar extends Sprite {
		
		public static const EMMIT_AREA_RECTANGLE:int = 0;
		public static const EMMIT_AREA_CIRCLE:int = 1;
		
		public static const EMMIT_SHOOT:int = 0;
		public static const EMMIT_WANDER:int = 1;
		
		private var startPx:Number = 0;
		private var startPy:Number = 0;
		private var beforePx:Number = 0;
		private var beforePy:Number = 0;
		
		private var beforeChkCount:int = 0;
		private var _checkIdleTime:int = 10;
		private var _checkIdleArea:int = 60;
		//private var fx:Number, fy:Number;
		private var cle_array:Vector.<StarShape> = new Vector.<StarShape>();
		private var _sessionId:uint;
		private var numCle:uint = 30;
		private var interval:uint = 100;
		private var intervalID:Number;
		private var isDisposing:Boolean = false;
		private var _wanderArea:Number = 150;
		private var _wanderAreaType:int = 0;
		private var _wanderAreaHalf:Number = 75;
		private var _starColor:uint = 0xffffff;
		private var _size:Number = 1;
		private var _sizeAtStart:Number = 0;
		private var _sizeDizz:Number = 0.2;
		private var _emmitType:int = 0;
		private var _glowColor:uint = 0;
		private var _glowSize:Number = 4;
		private var _rotationSpeed:Number = 1;
		
		/**
		 * 생성시 알파값 0~1
		 */
		public var alphaAtStart:Number = 1;
		/**
		 * 소멸시 알파값 0~1
		 */
		public var alphaAtFinish:Number = 0;
		/**
		 * alphaAtStart 의 랜돔 범위
		 */
		public var alphaDizzAtStart:Number = 0.1;
		/**
		 * alphaAtFinish 의 랜돔 범위
		 */
		public var alphaDizzAtFinish:Number = 0.1;
		
		/**
		 * 생성시 스케일 사이즈 
		 * @return 
		 * 
		 */
		public function get sizeAtStart():Number
		{
			return _sizeAtStart;
		}

		/**
		 * 생성시 스케일 사이즈 0~1
		 * @param value 
		 * 
		 */
		public function set sizeAtStart(value:Number):void
		{
			_sizeAtStart = value;
		}

		/**
		 * 글로우 효과 크기
		 * @return 
		 * 
		 */
		public function get glowSize():Number
		{
			return _glowSize;
		}

		/**
		 * 글로우 효과 크기
		 * @param value 픽셀값
		 * 
		 */
		public function set glowSize(value:Number):void
		{
			_glowSize = value;
		}

		/**
		 * 파티클 회전 속도 
		 * @return 0~1
		 * 
		 */
		public function get rotationSpeed():Number
		{
			return _rotationSpeed;
		}

		/**
		 * 파티클 회전 속도
		 * @param value 0~1
		 * 
		 */
		public function set rotationSpeed(value:Number):void
		{
			_rotationSpeed = value;
		}

		/**
		 * 활동 시간동안 스케일 조정값
		 * @return 
		 * 
		 */
		public function get sizeDizz():Number
		{
			return _sizeDizz;
		}

		public function set sizeDizz(value:Number):void
		{
			_sizeDizz = value;
		}

		public function get size():Number

		{
			return _size;
		}

		public function set size(value:Number):void

		{
			_size = value;
		}

		public function get glowColor():uint

		{
			return _glowColor;
		}

		public function set glowColor(value:uint):void

		{
			_glowColor = value;
		}

		public function get emmitType():int {
			return _emmitType;
		}
		
		/**
		 * star의 속도
		 */		
		public var moveSpeed:Number = 0.05;
		
		/**
		 * 포지션의 이동이 미미할 경우 자동종료를 시킬지 여부
		 * 기본 : true
		 * @see checkIdleArea, checkIdleTime
		 */
		public var isFinishInIdle:Boolean = true;
		
		
		public function get starColor():uint

		{
			return _starColor;
		}

		public function set starColor(value:uint):void

		{
			_starColor = value;
		}

		public function get wanderAreaType():int

		{
			return _wanderAreaType;
		}

		public function set wanderAreaType(value:int):void

		{
			_wanderAreaType = value;
		}

		public function get wanderArea():Number

		{
			return _wanderArea;
		}

		public function set wanderArea(value:Number):void

		{
			_wanderArea = value;
			_wanderAreaHalf = value / 2;
		}

		public function get checkIdleArea():int

		{
			return _checkIdleArea;
		}

		public function set checkIdleArea(value:int):void

		{
			_checkIdleArea = value;
		}

		public function get checkIdleTime():int

		{
			return _checkIdleTime;
		}

		public function set checkIdleTime(value:int):void

		{
			_checkIdleTime = value;
		}

		public function get starType():int

		{
			return _starType;
		}

		public function set starType(value:int):void

		{
			_starType = value;
			var i:int = 0;
			for(i; i< numCle; i++){
				cle_array[i].type = value;
			}
		}

		public function set shootingInterval(value:uint):void {
			
			interval = value;
			
			if(_sessionId != 0) {
				clearInterval(intervalID);
				intervalID = setInterval(renderStart, interval);
			}
		}
		
		public function get bulletTotal():uint {
			return numCle;
		}
		
		public function get sessionId():uint{
			return _sessionId;
		}
		
		public function set sessionId(sessionId:uint):void{
			this._sessionId = sessionId;
		}
		
		override public function set x(value:Number):void {
			this.startPx = value;
			//this.fx = value;
		}
		
		override public function get x():Number {
			return this.startPx;
		}
		
		override public function set y(value:Number):void {
			this.startPy = value;
			//this.fy = value;
		}
		
		override public function get y():Number {
			return this.startPy;
		}
		
		private var _starType:int = 0;
		
		
		/**
		 * 슈팅스타 생성자
		 * @param bulletTotal 스타 개수
		 * @param emmitType 스타 움직임
		 * @param starPixelWidth 스타의 기본 픽셀 가로
		 * @param starPixelHeight 스타의 기본 픽셀 세로
		 * 
		 */
		public function ShootingStar(bulletTotal:uint = 30, emmitType:int = 0, starPixelWidth:uint = 10, starPixelHeight:uint = 10):void {
			Hansune.copyright();
			
			this.numCle = bulletTotal;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this._emmitType = emmitType;
			//trace(_emmitType);
			startPx = 0;
			startPy = 0;
			
			var i:int = 0;
			for(i; i< numCle; i++){
				var star:StarShape = new StarShape(_starType, starPixelWidth, starPixelHeight);
				star.ready = true;
				star.visible = false;
				cle_array.push(star);
			}
		}
		
		/**
		 * start 
		 * 
		 */
		public function init():void {
			
			if(_sessionId == 0) _sessionId = getTimer();
			
			beforeChkCount = 0;
            clearInterval(intervalID);
			intervalID = setInterval(renderStart, interval);
			this.addEventListener(Event.ENTER_FRAME, render);
		}
		
		/**
		 * 자연 소멸되도록 한다.
		 */
		public function finish():void {
			isDisposing = true;
			clearInterval(intervalID);
		}
		
		/**
		 * 렌더링을 멈춘다.
		 * 
		 */
		public function pause():void {
			clearInterval(intervalID);
			this.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		/**
		 * 모든 것을 삭제한다.
		 * 
		 */
		public function dispose():void {
			clearInterval(intervalID);
			this.removeEventListener(Event.ENTER_FRAME, render);
			var len:uint = numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				removeChildAt(0);
			}
			
		}
		
		/**
		 * 재시작한다.
		 * 
		 */
		public function resume():void {
			var star:StarShape = null;
			var i:int = 0;
			var allinit:Boolean = true;
			for(i; i< numCle; i++){
				if(cle_array[i].ready){
					star = cle_array[i];
					allinit = false;
					break;
				}
			}
			
			if(!allinit && _emmitType == EMMIT_WANDER) {
				intervalID = setInterval(renderStart, interval);
			}
			else if(_emmitType == EMMIT_SHOOT) {
				intervalID = setInterval(renderStart, interval);
			}
			
			this.addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function renderStart():void {
			
			var star:StarShape = null;
			var i:int = 0;
			var allinit:Boolean = true;
			for(i; i< numCle; i++){
				if(cle_array[i].ready){
					star = cle_array[i];
					allinit = false;
					break;
				}
			}
			if(allinit && _emmitType == EMMIT_WANDER) {
				clearInterval(intervalID);
				return;
			}
			
			
			if(star == null) return;
			
			star.ready = false;
			star.visible = true;
			star.alpha = Math.min(1, alphaAtStart + Math.random() * alphaDizzAtStart - (alphaDizzAtStart/2));
			star.x = star.fx = startPx;
			star.y = star.fy = startPy;
			star.targetScale = Math.min(1 , _size + Math.random() * _sizeDizz - (_sizeDizz/2));
			star.scale = Math.min(1 , _sizeAtStart + Math.random() * _sizeDizz - (_sizeDizz/2));
			star.targetAlpha = Math.min(1, alphaAtFinish + Math.random() * alphaDizzAtFinish - (alphaDizzAtFinish/2));
			star.rotationPlus = rotationSpeed;
			star.rotation = int(Math.random()*360);
			star.ix = star.x;
			star.iy = star.y;
			
			if(_wanderAreaType == EMMIT_AREA_CIRCLE) {
				star.tx = star.x + Math.cos(Math.random() * Math.PI * 2) * _wanderArea;
				star.ty = star.y + Math.sin(Math.random() * Math.PI * 2) * _wanderArea;
			}
			else {
				star.tx = star.x + Math.random()*_wanderArea-_wanderAreaHalf;
				star.ty = star.y + Math.random()*_wanderArea-_wanderAreaHalf;
			}
			
			if(_emmitType == EMMIT_WANDER) {
				star.x = star.tx;
				star.y = star.ty;
			}
			
			star.color = _starColor;
			star.distort = Math.random()*0.2 + 1.1;
			//star.glow = Math.min(12, star.targetScale);
			
			GLOW(star, _glowColor, 1, _glowSize, 1);
			star.cacheAsBitmap = true;
			//BLUR(star,star.glow,star.glow,1);
			//star.blendMode = "add";
			addChild(star);
			
			if(isFinishInIdle) 
			{
				beforeChkCount ++;
				
				if(beforeChkCount > checkIdleTime){
					if(Math.abs(beforePx - startPx) < checkIdleArea && Math.abs(beforePy - startPy) < checkIdleArea){
						finish();
						return;
					}
					beforeChkCount = 0;
					beforePx = startPx;
					beforePy = startPy;
				}
			}
			
		}
		
		private function render(e:Event):void {
			
			var star:StarShape
			var i:int = 0;
			var length:uint = cle_array.length;
			
			for(i; i<length; i++){
				
				star = cle_array[i];
				
				if(!star.ready && star.visible){
					
					star.ix += (star.tx - star.ix) * moveSpeed;
					star.iy += (star.ty - star.iy) * moveSpeed;
					
					star.x += (star.ix - star.x) * moveSpeed;
					star.y += (star.iy - star.y) * moveSpeed;
					
					star.scale += (star.targetScale - star.scale) * moveSpeed;
					star.rotation += star.rotationPlus;
					
					
					if(_emmitType == EMMIT_SHOOT) 
					{
						if (Math.abs(star.tx - star.ix)< _wanderAreaHalf * 0.3 
							&& Math.abs(star.ty - star.iy) < _wanderAreaHalf * 0.3)
						{
							star.alpha += (star.targetAlpha - star.alpha) * 0.08;
							
							if (Math.abs(star.targetAlpha - star.alpha) < 0.1) {
								star.ready = true;
								star.visible = false;
								if(this.contains(star)) removeChild(star);
								if(isDisposing && this.numChildren < 1){
									this.removeEventListener(Event.ENTER_FRAME, render);
									cle_array = null;
									this.dispatchEvent(new Event(Event.COMPLETE));
									//trace("CleShootingStar finished", _sessionId);
									break;
								}
							}
						}
					}
					
					else if(_emmitType == EMMIT_WANDER)
					{
						if (Math.abs(star.tx - star.ix)< _wanderAreaHalf * 0.5
							&& Math.abs(star.ty - star.iy) < _wanderAreaHalf * 0.5)
						{
							if(isDisposing) {
								star.alpha += (star.targetAlpha - star.alpha) * 0.08;
								if (Math.abs(star.targetAlpha - star.alpha) < 0.1) {
									star.ready = true;
									star.visible = false;
									if(this.contains(star)) removeChild(star);
									if(this.numChildren < 1){
										this.removeEventListener(Event.ENTER_FRAME, render);
										cle_array = null;
										this.dispatchEvent(new Event(Event.COMPLETE));
										break;
									}
								}
							}
							else {
								star.targetScale = Math.random()*3 + 1;
								star.targetAlpha = Math.min(1, alphaAtFinish + Math.random() * alphaDizzAtFinish - (alphaDizzAtFinish/2));
								
								if(_wanderAreaType == EMMIT_AREA_CIRCLE) {
									star.tx = star.fx + Math.cos(Math.random() * Math.PI * 2) * _wanderArea;
									star.ty = star.fy + Math.sin(Math.random() * Math.PI * 2) * _wanderArea;
								}
								else {
									star.tx = star.fx + Math.random()*_wanderArea-_wanderAreaHalf;
									star.ty = star.fy + Math.random()*_wanderArea-_wanderAreaHalf;
								}
							}
						}
					}
					
				}
			}
		}
		
		///////////////////////////////////////////////////////////////
		////////////////////glow function //////////////////////////////
		///////////////////////////////////////////////////////////////
		private function GLOW(object:Object,color:Number,alpha:Number,blurXY:Number,quality:Number):void {
			var filter:BitmapFilter = getGlowFilter(color,alpha,blurXY,quality);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			object.filters = myFilters;
		}
		private function GLOW_DEL(object:Object):void {
			object.filters = null;
		}
		
		private function getGlowFilter(color:Number,alpha:Number,blurXY:Number,quality:Number):BitmapFilter {
			//var color:Number = 0x000000;
			//var alpha:Number = 0.24;
			var blurX:Number = blurXY;
			var blurY:Number = blurXY;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			switch (quality) {
				case 1 :
					quality = BitmapFilterQuality.LOW;
					break;
				case 2 :
					quality = BitmapFilterQuality.MEDIUM;
					break;
				case 3 :
					quality = BitmapFilterQuality.HIGH;
					break;
			}
			
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}
		////////////////////////////////////////////////////////////////
		/////////////////Blur/////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		private function BLUR(object:Object,blurX:Number,blurY:Number,quality:Number):void {
			
			var blurFilter:BlurFilter = new BlurFilter(blurX, blurY, quality);
			var myFilters:Array = new Array();
			myFilters.push(blurFilter);
			object.filters = myFilters;
			
		}
		private function BLUR_DEL(object:Object):void {
			object.filters = null;
		}
	}
}
//////////////////////////////////////////////////
