package hansune.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import hansune.Hansune;
	
	/**
	 * ...
	 * @author hanhyonsoo / blog.hansune.com
	 */
	
	[Event(name="change", type="flash.events.Event")]
	public class ScrollBar extends Sprite
	{
		
		private var _dragableLength:Number;//드래그 할 수 있는 길이
		private var _postion:Number = 0;//스크롤 바의 위치 0~1.0
		private var _scrollback:Sprite;//스크롤 배경
		private var _scrollbar:Sprite;//스크롤 바
		private var _scrollbarLength:Number;//스크롤 바의 길이
		private var _isDown:Boolean;//마우스 다운 여부
		private var _style:String;//가로, 세로 형태 인지 결정, ScrollBarStyle  참조
		
		private var _targetLength:Number;//스크롤 되는 대상의 길이
		private var _baseLength:Number;//스크롤 배경의 길이
		
		/**
		 * 스크롤 바의 0위치가 있는 앞 간격, 스크롤 배경 대비
		 * */
		 
		public var initSpan:Number = 0.0;
		/**
		 * 스크롤 바의 1.0 위치가 있는 뒤 간격, 스크롤 배경 대 비
		 * */
		public var endSpan:Number = 0.0;
		/**
		 * 드래그 영역
		 * */
		public var dragRect:Rectangle;	
		
		/**
		 * 드래그 위치 입력 0~1.0
		 */
		public function set position(rate:Number):void {
			if(!_updated) {_postion = rate; return;}
			_setPosition(rate);
			_postion = rate;
		}
		
		/**
		 * 드래그 위치
		 */
		public function get position():Number {
			return  _postion;
		}
		
		/**
		 * 스크롤 되는 대상의 길이 지정
		 */
		public function set targetLength(value:Number):void {
			_targetLength = value;
			_update();
		}
		
		/**
		 * 스크롤 배경의 길이
		 */
		public function set baseLength(value:Number):void {
			_baseLength = value;
			_update();
		}
		
		/**
		 * 스크롤 바 생성
		 * 
		 * @param	scrollLength / 스크롤 배경의 길이
		 * @param	scrolledLength / 스크롤 되는 대상의 길이
		 * @param	scrollBarStyle / 스크롤 스타일
		 */
		
		public function ScrollBar(scrollLength:Number=100, scrolledLength:Number=100,scrollBarStyle:String="v"):void
		{
			
			Hansune.copyright();
			
			_baseLength = scrollLength;
			_targetLength = scrolledLength;
			_style = scrollBarStyle;

		}
		
		/**
		 * 스크롤 배경이나 대상의 길이가 변할 경우 업데이트
		 */
		private var _updated:Boolean = false;
		private function _update():void {
			_scrollbarLength = Math.min(_baseLength, _baseLength * (_baseLength / _targetLength));
			_dragableLength = _baseLength - initSpan - endSpan - _scrollbarLength;
			
			if (_style == ScrollBarStyle.HORIZON ) {
				dragRect = new Rectangle(initSpan, 0, _dragableLength, 0);	
				
				if (_scrollbar == null) _scrollbar = new Sprite();
				_scrollbar.graphics.clear();
				_scrollbar.graphics.beginFill(0x005878);
				_scrollbar.graphics.drawRect(0, 0, _scrollbarLength, 10);
				_scrollbar.graphics.endFill();
				
				if (_scrollback == null) _scrollback = new Sprite();
				_scrollback.graphics.clear();
				_scrollback.graphics.beginFill(0xcccccc);
				_scrollback.graphics.lineStyle(1, 0x666666, 1, false, "none");
				_scrollback.graphics.drawRect(0, 0, _baseLength, 10);
				_scrollback.graphics.endFill();
				
				//스크롤 바가 영역 밖으로 나가는 것을 방지
				if ((_scrollbar.x + _scrollbar.width) > initSpan + _baseLength) {
					_scrollbar.x = _scrollbar.x - ( (_scrollbar.x + _scrollbar.width) - (initSpan + _baseLength));
				}
			}
			else 
			{
				dragRect = new Rectangle(0, initSpan, 0, _dragableLength);
				
				if (_scrollbar == null) _scrollbar = new Sprite();
				_scrollbar.graphics.clear();
				_scrollbar.graphics.beginFill(0xff5878);
				_scrollbar.graphics.drawRect(0, 0, 5, _scrollbarLength);
				_scrollbar.graphics.endFill();
				
				if (_scrollback == null) _scrollback = new Sprite();
				_scrollback.graphics.clear();
				_scrollback.graphics.beginFill(0xcccccc);
				_scrollback.graphics.lineStyle(1, 0x666666, 1, false, "none");
				_scrollback.graphics.drawRect(0, 0, 5, _baseLength);
				_scrollback.graphics.endFill();
				
				//스크롤 바가 영역 밖으로 나가는 것을 방지
				if ((_scrollbar.y + _scrollbar.height) > initSpan + _baseLength) {
					_scrollbar.y = _scrollbar.y - ( (_scrollbar.y + _scrollbar.height) - (initSpan + _baseLength));
				}
				
			}
			
			_updated = true;
		}
		
		/**
		 * 스크롤 시작
		 */
		
		public function start():void {			
			_update();
			
			addChildAt(_scrollback, 0);
			addChildAt(_scrollbar, 1);
			
			_isDown = false;
			_setPosition(_postion);
			
			
			_scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, _down);
			this.addEventListener(MouseEvent.MOUSE_MOVE, _move);
			this.addEventListener(MouseEvent.MOUSE_UP, _up);
			this.addEventListener(MouseEvent.MOUSE_OUT, _out);
			
		}
		/**
		 * 스크롤 끝/ 이벤트 제거
		 */
		public function end():void {
			removeChild(_scrollback);
			removeChild(_scrollbar);
			_scrollbar.removeEventListener(MouseEvent.MOUSE_DOWN, _down);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, _move);
			this.removeEventListener(MouseEvent.MOUSE_UP, _up);
			this.removeEventListener(MouseEvent.MOUSE_OUT, _out);
		}
		
		/**
		 * 스크롤 바의 위치 지정
		 * @param	rate / 스크롤 바가 드래그 영역 내에 위치하는 비율
		 */
		
		private function _setPosition(rate:Number):void {
			
			if (_style == ScrollBarStyle.HORIZON ) {
				_scrollbar.x = initSpan + rate * (_dragableLength);
			} else {
				_scrollbar.y = initSpan + rate * (_dragableLength);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		private function _down(e:MouseEvent):void {
			_isDown = true;
			_scrollbar.startDrag(false, dragRect);
		}
		private function _up(e:MouseEvent):void {
			_isDown = false;
			_scrollbar.stopDrag();
		}
		
		private function _out(e:MouseEvent):void {
			_isDown = false;
			_scrollbar.stopDrag();
		}
		
		private function _move(e:MouseEvent):void {
			if (_isDown) {
				if (_style == ScrollBarStyle.HORIZON ) {
					_postion = (_scrollbar.x - initSpan) / _dragableLength;
				} else {
					_postion = (_scrollbar.y - initSpan) / _dragableLength;
				}
				
				// 스크롤 변화 이벤트 
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}