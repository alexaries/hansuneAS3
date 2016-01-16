package hansune.ui
{
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.clearTimeout;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;
    
    import hansune.assets.SimpleDialogBg;
    import hansune.motion.SooTween;
    import hansune.motion.easing.Cubic;
    
    /**
     * <code>TraceView</code> 
     * @author hyonsoohan
     * 
     */
    public class TraceView extends EventDispatcher {
		
        
        /**
         * EasyDialog의 x 위치 
         * @param value
         * 
         */
        public static function set x(value:int):void {
            basisX = value;
        }
        /**
         * EasyDialog의 y 위치 
         * @param value
         * 
         */
        public static function set y(value:int):void {
            basisY = value;
        }
        
        private static const DEF_X:Number = 100;
        private static const DEF_Y:Number = 100;
        
        private static var basisX:Number = 100;
        private static var basisY:Number = 100;
        
        private const MARGIN:int = 4;
        private const SPACE:int = 5;
        private var alertTime:Number;
        private var timeId:Number;
        private var isViewing:Boolean = false;
        private var lb:TextField = new TextField();
        private var context:DisplayObject;
        private var id:Number = 0;
        private var clickFnc:Function;
        private var dimShape:Sprite;
        private var bg:Shape;
        private var container:Sprite;
		
		private static var instance:TraceView;
        
        public function set y(value:Number):void {
            container.y = value;
        }
        
        public function get y():Number {
            return container.y;
        }
        
        public function set x(value:Number):void {
            container.x = value;
        }
        
        public function get x():Number {
            return container.x;
        }
        
        
        /**
         * 다이어로그가 보일 경우 true
         * @return 
         * 
         */
        public function get isShowing():Boolean {
            return isViewing;
        }
        
        
		
		
        
        /**
         * SimpleDialog 생성자 
         * 
         */
        public function TraceView(t:TT){
			super();
        }
		
		
		public static function d(tag:String, message:String):void {
			if(instance == null) return;
			instance.d(tag, message);
		}
		
		
		public static function e(tag:String, message:String):void {
			if(instance == null) return;
			instance.e(tag, message);
		}
		
		private function d(t:String, s:String):void {
			lb.appendText(t + ", " + s + "\n");
			lb.scrollV = lb.numLines;
		}
		
		private function e(t:String, s:String):void {
			
			var h:String = "<font color='#ff0000'>" + e + ", " + s +"</font><br/>";
			lb.htmlText = h;
		}
		
		
        private function show():void {
            
            isViewing = true;
            if(container == null) container = new Sprite();
            
            var w:Number, h:Number;
            
			w = 500 + MARGIN + MARGIN;
			h = 500 + MARGIN + MARGIN;
			
			if(bg == null) bg = new Shape();
			bg.graphics.beginFill(0x55000000);
			bg.graphics.drawRect(0, 0, 500, 500);
			bg.graphics.endFill();
			bg.width = w;
			bg.height = h;
			
			lb.width = 500;
			lb.height = 500;
			
			container.addChild(bg);
			container.addChild(lb);
			
			
            if(context.stage != null)
            {				
				context.stage.addChild(container);
            }
        }
		
		private function hide():void{
            isViewing = false;
            container.removeChild(bg);
            container.removeChild(lb);
			
            if(context.stage != null && context.stage.contains(container))
            {
                context.stage.removeChild(container);
            }
            
        }
		
		public static function hide():void {
			instance.hide();
		}
        
		
        public static function show(context:DisplayObject):void {
            if(instance == null) instance = TraceView.create(context);
			instance.show();
        }
        
        private static function create(context:DisplayObject):TraceView{
            
            var fm:TextFormat = new TextFormat("Lucida Grande", 12, 0xffffff);
            fm.bold = true;
            var dialog:TraceView = new TraceView(new TT());
            
            dialog.context = context;
            dialog.isViewing = false;
            dialog.lb.defaultTextFormat = fm;
            dialog.lb.mouseEnabled = false;
            
            return dialog;
            
        }
		
		
    }
	
}

class TT {}