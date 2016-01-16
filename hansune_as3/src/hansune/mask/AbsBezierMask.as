package hansune.mask
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class AbsBezierMask extends Sprite
	{
		
		public function AbsBezierMask()
		{
			_shape = new Sprite();
			_shape.addEventListener(MouseEvent.MOUSE_DOWN, _onShapeDown);
			_shape.addEventListener(MouseEvent.MOUSE_UP, _onShapeOut);
			_shape.addEventListener(MouseEvent.MOUSE_OUT, _onShapeOut);
			_shape.useHandCursor = true;
			_shape.buttonMode = true;
			addChild(_shape);
			
			_center = new Shape();
			_center.graphics.lineStyle(1,0);
			_center.graphics.moveTo(0,-4);
			_center.graphics.lineTo(0,4);
			_center.graphics.moveTo(-4,0);
			_center.graphics.lineTo(4,0);

			addChild(_center);
		}
		
		protected var _center:Shape;
		protected var _color:uint = 0xff0000;
		protected var _data:Array;
		protected var _info:AbsBezierInfo;
		protected var _initInfo:AbsBezierInfo;
		protected var _shape:Sprite;
		protected var handles:Vector.<BezierHandle>;
		/**
		 * 모서리 라운딩
		 * @return 
		 */
		public function get round():Number{return _info.round;}

		/**
		 * 모서리 라운딩
		 * @param value
		 */
		public function set round(value:Number):void{
			_info.round = value;
			_update();
		}
		
		internal var defaultInfo:AbsBezierInfo;
		
		/**
		 * 핸들러 보이기
		 */
		public function viewHandle():void 
		{
			for(var i:int = 0; i < info.positionNums; ++i){
				if(!contains(handles[i])) addChild(handles[i]);
				handles[i].addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
				handles[i].addEventListener(MouseEvent.MOUSE_MOVE, _onMove);
				handles[i].useHandCursor = true;
				handles[i].buttonMode = true;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onOut);

			_update();
		}
		
		/**
		 * 핸들러 숨기기
		 */
		public function hideHandle():void 
		{
			for(var i:int = 0; i < info.positionNums; ++i){
				if(contains(handles[i])) removeChild(handles[i]);
				handles[i].removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
				handles[i].removeEventListener(MouseEvent.MOUSE_MOVE, _onMove);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onOut);
			_update();

		}

		/**
		 * left bottom
		 * @return 
		 */
		public function get lb():BezierHandle{return handles[3];}

		/**
		 * left bottom
		 * @param value
		 */
		public function set lb(value:BezierHandle):void{handles[3] = value;}
		/**
		 * left top
		 * @return 
		 */
		public function get lt():BezierHandle{return handles[0];}
		
		/**
		 * left top
		 * @param value
		 */
		public function set lt(value:BezierHandle):void{handles[0] = value;}
		
		public function get maskShape():Sprite {return _shape;}
		
		/**
		 * right bottom
		 * @return 
		 */
		public function get rb():BezierHandle{return handles[2];}
		
		/**
		 * right bottom
		 * @param value
		 */
		public function set rb(value:BezierHandle):void{handles[2] = value;}
		/**
		 * right top
		 * @return 
		 */
		public function get rt():BezierHandle{return handles[1];}

		/**
		 * right top
		 * @param value
		 */
		public function set rt(value:BezierHandle):void{handles[1] = value;}
		
		
		//라인 업데이트 
		protected function _lineUpdate():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x00ff00);
			this.graphics.moveTo(handles[0].x, handles[0].y);
			this.graphics.lineTo(handles[1].x, handles[1].y);
			this.graphics.lineTo(handles[2].x, handles[2].y);
			this.graphics.lineTo(handles[3].x, handles[3].y);
			this.graphics.lineTo(handles[0].x, handles[0].y);
		}
		
		protected function _onDown(e:MouseEvent):void{
			(e.currentTarget as Sprite).startDrag();
		}

		protected function _onMove(e:MouseEvent):void{
			_lineUpdate();
		}

		protected function _onOut(e:MouseEvent):void{
			for(var i:int=0; i< info.positionNums; ++i) {
				handles[i].stopDrag();
			}
			
			_update();
		}
		
		protected function _onShapeDown(e:MouseEvent):void{
			this.startDrag();
		}
		protected function _onShapeOut(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		protected function getProperty(name:String):String{
			var chk:Boolean = false;
			for(var i:int=0;i<_data.length;++i){
				if (name == _data[i].name) {
					chk = true;
					break;
				}
			}
			if(chk){
				//trace(name, _data[i].value);
				return _data[i].value;
			} else {
				trace(name, "null");
				return "0";
			}
		}
		
		internal function _update():void{}
		internal function fitToInitSize():void {fitToInfo(_initInfo);}
		internal function fitToRect():void{_update();}

		internal function fitToInfo(bezierInfo:AbsBezierInfo):void
		{
			for(var i:int=0; i<bezierInfo.positionNums; ++i){
				handles[i].x = bezierInfo.position[i].x;
				handles[i].y = bezierInfo.position[i].y;
			}
			this.x = bezierInfo.x;
			this.y = bezierInfo.y;
			if(bezierInfo.style == BezierMaskStyle.RECTANGLE) this._info.round = bezierInfo.round;
			_update();
		}
		
		public function get info():AbsBezierInfo
		{
			for(var i:int=0; i<_info.positionNums; ++i){
				_info.position[i].x = handles[i].x;
				_info.position[i].y = handles[i].y;
			}
			_info.x = this.x;
			_info.y = this.y;
			if(_info.style == BezierMaskStyle.RECTANGLE) this._info.round = this.round;
			
			return _info;
		}
		
		internal function getSaveString():String{
			return info.getSaveString();
		}
		
		internal function updateByData(dataArray:Array):void
		{
			_data = dataArray;
			var posTxt:String;
			var pos:Array = [];
		
			for (var i:int = 0; i< _info.positionNums; ++i){
				posTxt = getProperty("handle"+i);
				pos = posTxt.split("_");
				handles[i].x = _info.position[i].x = parseInt(pos[0]);
				handles[i].y = _info.position[i].y = parseInt(pos[1]);
			}
			
			this.x = _info.x = parseInt(getProperty("x"));
			this.y = _info.y = parseInt(getProperty("y"));
			
			if(_info.style == BezierMaskStyle.RECTANGLE)
				_info.round = parseInt(getProperty("round"));
			
			_initInfo = _info.clone();
			
			_update();
		}
	}
}