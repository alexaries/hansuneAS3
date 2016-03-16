package hansune.ui
{
	import flash.display.InteractiveObject;
	import flash.display.NativeMenuItem;
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
		private var contextMenu:ContextMenu;
		private var _iObject:InteractiveObject;
		
		/**
		 * EasyContextMenuAIR 의 내부 ContextMenu 를 반환한다.
		 * @return ContextMenu
		 * 
		 */
		public function get context():ContextMenu
		{
			return contextMenu;
		}
        
        /**
         * <p>true 이면, EXIT 선택시 프로그램 종료를 하지 않고, Event.CLOSE 이벤트를 보낸다.
         * Event.CLOSE 리스너를 등록하면 값이 자동으로 true 가 된다.</p>
         */
        public var hookingExit:Boolean = false;
		
		private static var instance:EasyContextMenuAIR;
		/**
		 * 클래스 인스턴스로  
		 * @return 
		 * 
		 */
		public static function getInstance():EasyContextMenuAIR {
			if(instance == null) {
				trace("Must call 'makeInstance' first.");
				return null;
			}
			return instance;
		}
		
		public function EasyContextMenuAIR(iObj:InteractiveObject, nWindow:NativeWindow) 
		{	
			Hansune.ver();
            
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			addCustomMenuItems();

			_iObject = iObj;
			_iObject.contextMenu = contextMenu;

			window = nWindow;

			instance = this;
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

			var item2:NativeMenuItem = new ContextMenuItem("[ MENU ]");
			var item4:NativeMenuItem = new ContextMenuItem("Show Mousepoint", true);
			var item5:NativeMenuItem = new ContextMenuItem("Hide Mousepoint");
			var item8:NativeMenuItem = new ContextMenuItem("FullScreen - No Scale");
			var item7:NativeMenuItem = new ContextMenuItem("NormalScreen - Show All");
			var item9:NativeMenuItem = new ContextMenuItem("EXIT");
			
			contextMenu.addItem(item2);
			contextMenu.addItem(item4);
			contextMenu.addItem(item5);
			contextMenu.addItem(item8);
			contextMenu.addItem(item7);
			contextMenu.addItem(item9);

			item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showMousepoint);
			item5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, hideMousepoint);
			item8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullScreen);
			item7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, normalScreen);
			item9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, exit);
		}
		
		/**
		 * 메뉴 추가 
		 * @param label 메뉴 이름
		 * @param contextListener ContextMenuEvent 리스너
		 * 
		 */
		public function addMenuItem(label:String, contextListener:Function):void {
			
			var item:NativeMenuItem;
			if(contextMenu.numItems == 6)
			{
				item = new ContextMenuItem(label,  true);
			}
			else 
			{
				item = new ContextMenuItem(label);
			}
			contextMenu.addItem(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextListener);
		}
		
		/**
		 * 메뉴 삭제
		 * @param label 삭제할 메뉴의 이름 
		 * 
		 */		
		public function removeMenuItem(label:String):void {
			
			var index:int = -1;
			for (var i:int = 0; i < contextMenu.numItems; i++) 
			{
				if(contextMenu.getItemAt(i).label == label) {
					index = i;
					break;
				}
			}
			
			if(index > -1) contextMenu.removeItemAt(index);
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
		 * Show mouse point
		 * @param event
		 * 
		 */
		public function showMousepoint(event:ContextMenuEvent = null):void {
			Mouse.show();
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
			_iObject.stage.scaleMode = StageScaleMode.SHOW_ALL;
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



