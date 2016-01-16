
package hansune.viewer.zoomViewer
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com
	 * 
	 * 확대 축소 배율 표시

	 */
	public class ZoomUI extends Sprite
	{
		
		private var _plus:Sprite;
		private var _minus:Sprite;
		private var _basis:Sprite;
		private var _rateUI:ZoomRate;
		private var _currentZoom:Number;
		
		/**
		 * 최대 줌 비율
		 * */
		public var zoomMax:Number = 2.0;
		/**
		 * 최소 줌 비율
		 * */
		public var zoomMin:Number = 0.1;
		/**
		 * viewRect zoomUI가 움직일 수 있는 범위 지정
		 * */
		public var viewRect:Rectangle;
		
		public function ZoomUI() 
		{
			_rateUI = new ZoomRate();
			_rateUI.rate = 1.0;
			addChild(_rateUI);
			_rateUI.visible = false;
			
			_plus = _makePlus();
			_minus = _makeMinus();
			_basis = _makeBasis();
			addChild(_plus);
			addChild(_minus);
			addChild(_basis);
			
			_plus.visible = false;
			_minus.visible = false;
			_basis.visible = false;
		}
		
		/**
		 * 확대축소 표시를 시작한다.
		 * @param	xx viewRect 안에서 마우스 x위치
		 * @param	yy viewRect 안에서 마우스 y위치
		 * @param	currentZoom 시작할 확대비율, 실제 배율이 아닌 zoomUI에 보이는 비율
		 */
		
		public function startAt(xx:Number, yy:Number, currentZoom:Number):void {
			_rateUI.visible = false;
			_rateUI.rate = currentZoom;
			_currentZoom = currentZoom;
			
			if (xx < viewRect.width / 2) {
				_basis.x = viewRect.right - 60;
				_basis.y = yy;
				_plus.x = viewRect.right - 60;
				_plus.y = _basis.y - _plus.height;
				_minus.x = viewRect.right - 60;
				_minus.y = _basis.y + _minus.height;
				_rateUI.x = _basis.x;
				
			} else {
				_basis.x = viewRect.left + 60;
				_basis.y = yy;
				_plus.x = viewRect.left + 60;
				_plus.y = _basis.y - _plus.height;
				_minus.x = viewRect.left + 60;
				_minus.y = _basis.y + _minus.height;
				_rateUI.x = _basis.x;
			}
			
			_plus.visible = true;
			_minus.visible = true;
			_basis.visible = true;
		}
		
		/**
		 * 마우스 좌표에 따라 배율을 조정
		 * @param	xx
		 * @param	yy
		 */
		
		public function addBy(xx:Number, yy:Number):void {
			var diff:Number = _basis.y - yy;
			var multi:Number = diff / 100;
			
			if (Math.abs(multi) > 0.1) _rateUI.visible = true;
			_rateUI.rate = Math.max(zoomMin, Math.min(zoomMax, _currentZoom + multi));
			
			if (multi > 0) {
				if(_rateUI.rate < zoomMax){
					_plus.y = Math.max(viewRect.top - _plus.height,_basis.y - multi * 100);
					_minus.y = _basis.y + _minus.height;
					_rateUI.y = _plus.y + _plus.height;
				}
			} 
			else {
				if(_rateUI.rate > zoomMin){
					_plus.y = _basis.y - _plus.height;
					_minus.y = Math.min(viewRect.bottom  - _minus.height, _basis.y - multi * 100);
					_rateUI.y = _minus.y + _minus.height;
				} 
			}
		}
		
		/**
		 * ui 표시 배율을 반환
		 * @return ui 표시 배율
		 */
		
		public function getRate():Number {
			return _rateUI.rate;
		}
		/**
		 * ui 표시 배율을 지정
		 * @param	val 지정할 배율
		 */
		public function setRate(val:Number):void {
			_rateUI.rate = val;
		}
		
		private function _makePlus():Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff);
			s.graphics.lineStyle(1, 0xff0000);
			s.graphics.lineTo( -10, 0);
			s.graphics.lineTo(0, -10);
			s.graphics.lineTo(10, 0);
			s.graphics.lineTo(0, 0);
			s.graphics.endFill();
			
			return s;
		}
		private function _makeMinus():Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff);
			s.graphics.lineStyle(1, 0xff0000);
			s.graphics.lineTo( -10, 0);
			s.graphics.lineTo(0, 10);
			s.graphics.lineTo(10, 0);
			s.graphics.lineTo(0, 0);
			s.graphics.endFill();
			
			return s;
		}
		
		private function _makeBasis():Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xffffff);
			s.graphics.lineStyle(1, 0xff0000);
			s.graphics.lineTo( -10, 0);
			s.graphics.lineTo(-10, 3);
			s.graphics.lineTo(10, 3);
			s.graphics.lineTo(10, 0);
			s.graphics.lineTo(0, 0);
			s.graphics.endFill();
			
			return s;
		}
		
	}
}