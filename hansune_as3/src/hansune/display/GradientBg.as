/*
 GradientBg v1.0
 Author: hyonsoo han - www.hansune.com
 Date Created: Mar. 8, 2009
 

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*/

package hansune.display {

	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import hansune.Hansune;
	import hansune.motion.easing.Quadratic;

	/**
	 * draw 가 완료됨 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	public class GradientBg extends Sprite {
		private var chk:Boolean = false;
		public var _speed:Number = 0.2;
		
		private var initialRect:Rectangle;
		private var completeRect:Rectangle;
		
		private var inAx:Number;
		private var inAy:Number;
		private var inBx:Number;
		private var inBy:Number;
		private var inCx:Number;
		private var inCy:Number;
		private var inDx:Number;
		private var inDy:Number;
		private var tgAx:Number;
		private var tgAy:Number;
		private var tgBx:Number;
		private var tgBy:Number;
		private var tgCx:Number;
		private var tgCy:Number;
		private var tgDx:Number;
		private var tgDy:Number;
		

		//gradient value
		private var type:String = GradientType.LINEAR;
		private var colors:Array = [];
		private var alphas:Array = [];
		private var ratios:Array = [];
		private var spreadMethod:String;
		private var interp:String;
		private var focalPtRatio:Number;
		private var matrix:Matrix = new Matrix();

		/**
		 *  
		 * 
		 */
		public function GradientBg(initialRect:Rectangle = null, completeRect:Rectangle = null):void {
			
			Hansune.copyright();
			
			if(initialRect == null) {
				this.initialRect = new Rectangle(0,0,0,0);
			} else {
				this.initialRect = initialRect;
			}
			if(completeRect == null) {
				this.completeRect = new Rectangle(0, 0, 400, 400);
			} else {
				this.completeRect = completeRect;
			}
			
			inAx = this.initialRect.topLeft.x;
			inAy = this.initialRect.topLeft.y;
			inBx = this.initialRect.right;
			inBy = this.initialRect.top;
			inCx = this.initialRect.bottomRight.x;
			inCy = this.initialRect.bottomRight.y;
			inDx = this.initialRect.left;
			inDy = this.initialRect.bottom;
			tgAx = this.completeRect.topLeft.x;
			tgAy = this.completeRect.topLeft.y;
			tgBx = this.completeRect.right;
			tgBy = this.completeRect.top;
			tgCx = this.completeRect.bottomRight.x;
			tgCy = this.completeRect.bottomRight.y;
			tgDx = this.completeRect.left;
			tgDy = this.completeRect.bottom;
			
			type = GradientType.LINEAR;
			colors = [0x000000, 0x000000];
			alphas = [1, 1];
			ratios = [0, 255];
			spreadMethod = SpreadMethod.PAD;
			interp = InterpolationMethod.LINEAR_RGB;
			focalPtRatio = 0;
			
			chk = true;
			
		}
		
		/**
		 *  드로잉 스피드
		 * @param value
		 * 
		 */
		public function set speed(value:Number):void {
			_speed = value;
		}
		
		
		/**
		 * 드로잉 중인지 여부
		 * @return 
		 * 
		 */
		public function get isDrawing():Boolean {
			return !chk;
		}
		
		/**
		 *  초기 위치로 변경
		 * 
		 */
		public function resetToInitial(newInitialRect:Rectangle = null):void {
			
			if(newInitialRect != null) {
				this.initialRect = newInitialRect.clone();
			}
			
			inAx = this.initialRect.topLeft.x;
			inAy = this.initialRect.topLeft.y;
			inBx = this.initialRect.right;
			inBy = this.initialRect.top;
			inCx = this.initialRect.bottomRight.x;
			inCy = this.initialRect.bottomRight.y;
			inDx = this.initialRect.left;
			inDy = this.initialRect.bottom;
			
			this.graphics.clear();
			this.removeEventListener(Event.ENTER_FRAME,approaching);
			
			with (this) {
				graphics.beginGradientFill(type,colors,alphas,ratios, matrix, spreadMethod, interp, focalPtRatio);
				graphics.moveTo(inAx, inAy);
				graphics.lineTo(inBx, inBy);
				graphics.lineTo(inCx, inCy);
				graphics.lineTo(inDx, inDy);
				graphics.endFill();
			}
		}
		
		/**
		 * 움직임 타겟을 변경 
		 * @param _tgAx
		 * @param _tgAy
		 * @param _tgBx
		 * @param _tgBy
		 * @param _tgCx
		 * @param _tgCy
		 * @param _tgDx
		 * @param _tgDy
		 * 
		 */
		public function targetToPoint(
							_tgAx:Number,_tgAy:Number,_tgBx:Number,_tgBy:Number,
							_tgCx:Number,_tgCy:Number,_tgDx:Number,_tgDy:Number):void {
//			inAx = tgAx;
//			inAy = tgAy;
//			inBx = tgBx;
//			inBy = tgBy;
//			inCx = tgCx;
//			inCy = tgCy;
//			inDx = tgDx;
//			inDy = tgDy;
			tgAx = _tgAx;
			tgAy = _tgAy;
			tgBx = _tgBx;
			tgBy = _tgBy;
			tgCx = _tgCx;
			tgCy = _tgCy;
			tgDx = _tgDx;
			tgDy = _tgDy;
		}
		
		/**
		 * 움직임 타겟을 변경 
		 * @param completeRect
		 * 
		 */
		public function targetToRect(completeRect:Rectangle):void {
			
//			this.initialRect = completeRect.clone();
			this.completeRect = completeRect.clone();
			
//			inAx = this.initialRect.topLeft.x;
//			inAy = this.initialRect.topLeft.y;
//			inBx = this.initialRect.right;
//			inBy = this.initialRect.top;
//			inCx = this.initialRect.bottomRight.x;
//			inCy = this.initialRect.bottomRight.y;
//			inDx = this.initialRect.left;
//			inDy = this.initialRect.bottom;
			tgAx = this.completeRect.topLeft.x;
			tgAy = this.completeRect.topLeft.y;
			tgBx = this.completeRect.right;
			tgBy = this.completeRect.top;
			tgCx = this.completeRect.bottomRight.x;
			tgCy = this.completeRect.bottomRight.y;
			tgDx = this.completeRect.left;
			tgDy = this.completeRect.bottom;
		}
		
		private var duration:Number = 0;
		private var easing:Function;
		private var starttime:int = 0;
		private var covered:Number = 0;
		//시작값
		private var sAx:Number = 0;
		private var sAy:Number = 0;
		private var sBx:Number = 0;
		private var sBy:Number = 0;
		private var sCx:Number = 0;
		private var sCy:Number = 0;
		private var sDx:Number = 0;
		private var sDy:Number = 0;
		/**
		 *  그리기 시작
		 * @param time 움직임 시간 (초), 지정하지 않으면 speed 값에 좌우하여 EaseOut 됨.
		 * @param ease Ease 기능 설정
		 * 
		 */
		public function draw(duration:Number = -1, ease:Function = null):void {
			if(chk){
				chk = false;
				this.duration = duration;
				starttime = getTimer();
				easing = (ease == null)? Quadratic.easeOut : ease;
				sAx= inAx;
				sAy = inAy;
				sBx = inBx;
				sBy = inBy;
				sCx = inCx;
				sCy = inCy;
				sDx = inDx;
				sDy = inDy;
				this.addEventListener(Event.ENTER_FRAME, approaching);
			}
		}
		
		/**
		 * 그리기 중이라면 정지하고, 한번에 그림
		 * 타겟으로 한번에 그린다.
		 */
		public function fit():void{
			
			this.graphics.clear();
			this.removeEventListener(Event.ENTER_FRAME,approaching);
			
			with (this) {
				graphics.beginGradientFill(type,colors,alphas,ratios, matrix, spreadMethod, interp, focalPtRatio);
				graphics.moveTo(tgAx,tgAy);
				graphics.lineTo(tgBx,tgBy);
				graphics.lineTo(tgCx,tgCy);
				graphics.lineTo(tgDx,tgDy);
				graphics.endFill();
			}
		}
		
		/**
		 * 그라데이션 설정. 
		 * @param _type 그라데이션 종류 GradientType
		 * @param _colors1 시작 컬러
		 * @param _colors2 끝나는 컬러
		 * @param _alphas1 시작 알파
		 * @param _alphas2 끝나는 알파
		 * 
		 */
		public function setGradient(_type:String,_colors1:Object,_colors2:Object,_alphas1:Number,_alphas2:Number):void {
			//gradient value
			type = _type;
			colors = [];
			colors.push(_colors1);
			colors.push(_colors2);

			ratios = [0, 255];
			spreadMethod = SpreadMethod.PAD;
			interp = InterpolationMethod.LINEAR_RGB;
			focalPtRatio = 0;

			var boxWidth:Number = 1000;
			var boxHeight:Number = 800;
			var boxRotation:Number = Math.PI/2;// 90˚
			var tx:Number = 25;
			var ty:Number = 0;

			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);

		}


		private function approaching(event:Event):void {
			
			if(duration < 0)
			{
			//// point vary
				if (Math.abs(inAx-tgAx)>2 || Math.abs(inAy-tgAy)>2) {
					inAx = inAx+(tgAx-inAx)*_speed;
					inAy = inAy+(tgAy-inAy)*_speed;
				} else {
					inAx = tgAx;
					inAy = tgAy;
				}
				if (Math.abs(inBx-tgBx)>2 || Math.abs(inBy-tgBy)>2) {
					inBx = inBx+(tgBx-inBx)*_speed;
					inBy = inBy+(tgBy-inBy)*_speed;
				} else {
					inBx = tgBx;
					inBy = tgBy;
				}
				if (Math.abs(inCx-tgCx)>2 || Math.abs(inCy-tgCy)>2) {
					inCx = inCx+(tgCx-inCx)*_speed;
					inCy = inCy+(tgCy-inCy)*_speed;
				} else {
					inCx = tgCx;
					inCy = tgCy;
				}
				if (Math.abs(inDx-tgDx)>2 || Math.abs(inDy-tgDy)>2) {
					inDx = inDx+(tgDx-inDx)*_speed;
					inDy = inDy+(tgDy-inDy)*_speed;
				} else {
					inDx = tgDx;
					inDy = tgDy;
				}
			}
			else 
			{
				var now:int = getTimer();
				//시간계산
				covered = (now - starttime) * 0.001;
				//속성 변경
				inAx = easing(covered, sAx, tgAx - sAx, duration);
				inAy = easing(covered, sAy, tgAy - sAy, duration);
				inBx = easing(covered, sBx, tgBx - sBx, duration);
				inBy = easing(covered, sBy, tgBy - sBy, duration);
				inCx = easing(covered, sCx, tgCx - sCx, duration);
				inCy = easing(covered, sCy, tgCy - sCy, duration);
				inDx = easing(covered, sDx, tgDx - sDx, duration);
				inDy = easing(covered, sDy, tgDy - sDy, duration);
				
				if (covered >= duration) {
					
					inAx = tgAx;
					inAy = tgAy;  
					inBx = tgBx; 
					inBy = tgBy;  
					inCx = tgCx;  
					inCy = tgCy;  
					inDx = tgDx;  
					inDy = tgDy;
				}
			}
			// draw point
			this.graphics.clear();
			this.graphics.beginGradientFill(type,colors,alphas,ratios, matrix, spreadMethod, interp, focalPtRatio);
			this.graphics.moveTo(inAx,inAy);
			this.graphics.lineTo(inBx,inBy);
			this.graphics.lineTo(inCx,inCy);
			this.graphics.lineTo(inDx,inDy);
			this.graphics.endFill();

			if (inAx == tgAx &&
				inAy == tgAy && 
				inBx == tgBx &&
				inBy == tgBy && 
			   inCx == tgCx && 
			   inCy == tgCy && 
			   inDx == tgDx && 
			   inDy == tgDy) {
				this.removeEventListener(Event.ENTER_FRAME,approaching);
				chk = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 이벤트 해제, 디스플레이 리스트 해제
		 * 
		 */
		public function release():void {
			this.removeEventListener(Event.ENTER_FRAME,approaching);
		}
	}
}