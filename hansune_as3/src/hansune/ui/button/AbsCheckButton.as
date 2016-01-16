package hansune.ui.button
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import hansune.events.ButtonEvent;
	
	[Event(name="fsClick", type="fs.events.StoreEvent")]
	public class AbsCheckButton extends AbstractButton
	{
		
		override public function get width():Number {
			return _engImg.width;
		}
		override public function get height():Number {
			return _engImg.height;
		}
		
		private var _checker:Bitmap;
		public function set checker(value:Bitmap):void {
			_checker = value;
			_checker.visible = false;
			addChild(_checker);
		}
		public function get checker():Bitmap {
			return _checker;
		}
		
		private var _engImg:Bitmap;
		public function set engImage(bm:Bitmap):void {
			_engImg = bm;
			addChildAt(_engImg, 0);
		}
		
		private var _chnImg:Bitmap;
		public function set chnImage(bm:Bitmap):void {
			_chnImg = bm;
			addChildAt(_chnImg, 0);
		}
		
		public var selectToggle:Boolean = true;//강제로 선택무 상태를 고정시키기 위한 변수
		private var _selected:Boolean = false;
		public function set selected(value:Boolean):void {
			_selected = value;
			if(value){
				setCheck();
			} else {
				setUncheck();
			}
		}
		
		public function get selected():Boolean {
			return (checker.visible);
		}
		
		protected var trans:Sprite;
		public function AbsCheckButton(checkerImage:Bitmap)
		{
			super();
			
			this.checker = checkerImage;
			
			trans = new Sprite();
			trans.graphics.beginFill(0);
			trans.graphics.drawRect(0,0,1,1);
			trans.graphics.endFill();
			trans.alpha = 0;
		}
		
		
		override public function set eventEnable(value:Boolean):void{
				if(value){		
					addChild(trans);
					trans.width = _engImg.width;
					trans.height = _engImg.height;
					trans.addEventListener(MouseEvent.CLICK, onClick);
					trans.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				} else {
					if(contains(trans)) removeChild(trans);
					trans.removeEventListener(MouseEvent.CLICK, onClick);
					trans.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				}
		}
		
		public function setMouseArea(xx:Number, yy:Number, ww:Number, hh:Number):void {
			trans.x = xx;
			trans.y = yy;
			trans.width = ww;
			trans.height = hh;
		}
		
		private var toggle:Boolean = false;
		public var selectTogglable:Boolean = true;
		private function onClick(e:MouseEvent):void {
			if(eventEnable) dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
			if(!selectTogglable) return;
			if(toggle){
				toggle = false;
				setUncheck();
			} else {
				toggle = true;
				setCheck();
			}
		}
		
		private function setUncheck():void {
			if(_lang){
				_engImg.alpha = 1.0;
				_engImg.visible = true;
				_chnImg.alpha = 1.0;
				_chnImg.visible = false;
				
				_checker.visible = false;
			} else {
				_engImg.alpha = 1.0;
				_engImg.visible = false;
				_chnImg.alpha = 1.0;
				_chnImg.visible = true;
				
				_checker.visible = false;
			}
		}
		
		private function setCheck():void {
			if(_lang){
				_engImg.alpha = 1.0;
				_engImg.visible = true;
				_chnImg.alpha = 1.0;
				_chnImg.visible = false;
				
				_checker.visible = true;
			} else {
				_engImg.alpha = 1.0;
				_engImg.visible = false;
				_chnImg.alpha = 1.0;
				_chnImg.visible = true;
				
				_checker.visible = true;
			}
		}
		
		private function onDown(e:MouseEvent):void {
			if(_lang){
				_engImg.alpha = 0.7;
			} else {
				_chnImg.alpha = 0.7;
			}
		}
		
		
		override protected function toChinese() : void {
			_chnImg.alpha = 1.0;
			_chnImg.visible = true;
			_engImg.alpha = 1.0;
			_engImg.visible = false;
		}
		
		override protected function toEnglish() : void {
			_chnImg.alpha = 1.0;
			_chnImg.visible = false;
			_engImg.alpha = 1.0;
			_engImg.visible = true;
		}
		
	}
}