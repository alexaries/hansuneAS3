package hansune.ui
{
	import flash.display.InteractiveObject;
	import flash.display.NativeWindow;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	
	import hansune.Hansune;

    
    /**
     * hookingExit 값이 true 일 때, 종료 명령이 수행되면 발생한다
     */
    [Event(name="close", type="flash.events.Event")]
    
	/**
	 * AIR 버전에서 사용하는 기본 컨텍스트 메뉴 클래스
	 * @author hansoo
	 */
	public class EasyContextMenuAIR extends EventDispatcher
	{
		private var window:NativeWindow;
		static private var _context:ContextMenu;
		private var _iObject:InteractiveObject;
		
		/**
		 * EasyContextMenuAIR 의 내부 ContextMenu 를 반환한다.
		 * @return ContextMenu
		 * 
		 */
		static public function get context():ContextMenu
		{
			return _context;
		}
        
        /**
         * <p>true 이면, EXIT 선택시 프로그램 종료를 하지 않고, Event.CLOSE 이벤트를 보낸다.
         * Event.CLOSE 리스너를 등록하면 값이 자동으로 true 가 된다.</p>
         */
        public var hookingExit:Boolean = false;
		
		public function EasyContextMenuAIR(iObj:InteractiveObject, nWindow:NativeWindow) 
		{	
			Hansune.ver();
            
			_context = new ContextMenu();
			_context.hideBuiltInItems();
			addCustomMenuItems();

			_iObject = iObj;
			_iObject.contextMenu = _context;

			window = nWindow;

		}
        
        /**
         * 이벤트 리스너 등록, 
         * @param type Event.CLOSE 이면 자동으로 hookingExit 값이 true 가 된다.
         * @param listener
         * @param useCapture
         * @param priority
         * @param useWeakReference
         * 
         */
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            if(Event.CLOSE == type) hookingExit = true;
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        

		private function addCustomMenuItems():void {

			var item3:ContextMenuItem = new ContextMenuItem("--");
			//var item4:ContextMenuItem = new ContextMenuItem("", true);
			var item5:ContextMenuItem = new ContextMenuItem("Hide Mousepoint", true);
			
			var item8:ContextMenuItem = new ContextMenuItem("FullScreen - No Scale");
			var item7:ContextMenuItem = new ContextMenuItem("NormalScreen");
			var item9:ContextMenuItem = new ContextMenuItem("EXIT");
			
			_context.customItems.push(item3);
			//_context.customItems.push(item4);
			_context.customItems.push(item5);
			_context.customItems.push(item8);
			_context.customItems.push(item7);
			_context.customItems.push(item9);

			item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, hideMousepoint);
			item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullScreen);
			item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, normalScreen);
			item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, exit);
		}
		
		/**
		 * 컨텐스트 메뉴 추가 
		 * @param name 이름
		 * @param contextListener ContextMenuEvent 리스너
		 * 
		 */
		public function addMenuItem(name:String, contextListener:Function):void {
			
			var item:ContextMenuItem;
			if(_context.customItems.length == 6)
			{
				item = new ContextMenuItem(name,  true);
			}
			else 
			{
				item = new ContextMenuItem(name);
			}
			_context.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextListener);
		}
		
		/**
		 * 마우스 포인트 숨기기
		 * @param event
		 * 
		 */
		public function hideMousepoint(event:ContextMenuEvent = null):void {
			Mouse.hide();
		}
		
		/**
		 * 전체화면 모드, 스케일 모드는 StageScaleMode.NO_SCALE
		 * @param event
		 * 
		 */
		public  function fullScreen(event:ContextMenuEvent = null):void {
			window.stage.displayState = StageDisplayState.FULL_SCREEN;
			_iObject.stage.scaleMode = StageScaleMode.NO_SCALE;
			_iObject.scaleX = 1;
			_iObject.scaleY = 1;
		}
		
		
		/**
		 * 기본사이즈 모드 , 스케일 모드는 StageScaleMode.NO_SCALE
		 * @param event
		 * 
		 */
		public function normalScreen(event:ContextMenuEvent =  null):void {
			window.stage.displayState = StageDisplayState.NORMAL;
			_iObject.stage.scaleMode = StageScaleMode.NO_SCALE;
			_iObject.scaleX = 1;
			_iObject.scaleY = 1;
		}
		
		
		/**
		 * 종료 
		 * @param e
		 * 
		 */
		public function exit(e:ContextMenuEvent = null):void{
			if(hookingExit)
            {
                dispatchEvent(new Event(Event.CLOSE));
            }
            else {
                window.close();
            }
		}
	}
}

