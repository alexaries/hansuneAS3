package hansune.ui
{
    
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Point;
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
     * <code>CopyofEasyDialog</code> 를 통해 손쉽게 간단히 경고문구나 대화창을 띄울 수 있다. 
     * @author hyonsoohan
     * 
     */
    public class TotoroDialog extends EventDispatcher {
		
        
        /**
         * EasyDialog의 x 위치 
         * @param value
         * 
         */
        public static function set x(value:Number):void {
            basisX = value;
        }
        /**
         * EasyDialog의 y 위치 
         * @param value
         * 
         */
        public static function set y(value:Number):void {
            basisY = value;
        }
        
        /**
         * 화면 중앙에 놓을지 여부 / true이면 x, y 속성은 무시된다.
         * @param value
         * 
         */
        public static function set center(value:Boolean):void {
            isCenter = value;
        }
        
        /**
         * 바탕을 어둡게 할지 여부 
         * @param value
         * 
         */
        public static function set diming(value:Boolean):void {
            isDim = value;
        }
        
        private static const DEF_X:Number = 100;
        private static const DEF_Y:Number = 100;
        
        private static var dialogArray:Vector.<TotoroDialog> = new Vector.<TotoroDialog>();
        private static var basisX:Number = 100;
        private static var basisY:Number = 100;
        private static var isCenter:Boolean = false;
        private static var isDim:Boolean = false;
		
		
		[Embed(source="../../../embed/totoro.png")]
		private var totoroImg:Class;
		private var totoro:Bitmap;
        
        private const MARGIN:int = 4;
        private const SPACE:int = 5;
        private var alertTime:Number;
        private var timeId:Number;
        private var isViewing:Boolean = false;
        private var lb:TextField = new TextField();
        private var context:DisplayObject;
        private var isHideAfter:Boolean = true;
        private var id:Number = 0;
        private var button:TestButton;
        private var clickFnc:Function;
        private var dimShape:Sprite;
        private var bg:SimpleDialogBg;
        private var container:Sprite;
        
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
        
        public function get width():Number {
            return container.width;
        }
        
        public function get height():Number {
            return container.height;
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
         * 다이어로그의 메시지 글
         * @param value
         * 
         */
        public function set text(value:String):void {
            this.lb.text = value;
        }
        
        /**
         * 다어로그의 메시지 글글
         * @return 
         * 
         */
        public function get text():String {
            return this.lb.text;
        }
        
        /**
         * CopyofEasyDialog 생성자 
         * 
         */
        public function TotoroDialog(){
            id = getTimer();
            super();
            container = new Sprite();
			totoro = new totoroImg() as Bitmap;
			totoro.smoothing = true;
        }
        
        /**
         * <p>버튼을 추가하고자 할 경우 사용한다. 
         * 설정할 경우 자동으로 사라지지 않는다.</p>
         * @param btnName 버튼에 오버레이되는 글자
         * @param onClickFnc 버튼을 클릭할 경우 실행되는 function
         * @return 버튼이 포함된 CopyofEasyDialog 객체
         * 
         */
        public function setButton(btnName:String, onClickFnc:Function = null):TotoroDialog {
            isHideAfter = false;
            button = new TestButton(btnName);
            
            if(onClickFnc != null) {
                button.addEventListener(MouseEvent.CLICK, onClick);
                clickFnc = onClickFnc;
            }
            
            return this;
        }
        
        private function onClick(e:MouseEvent):void {
            hide();
            clickFnc();
        }
        
        
        /**
         * 다이어로그를 화면에 표시한다. 
         * @return CopyofEasyDialog 객체
         * 
         */
        public function show():TotoroDialog {
            
            isViewing = true;
            if(isHideAfter){
                timeId = setTimeout(hide,alertTime);
            }
            
			TotoroDialog.dialogArray.push(this);
            if(container == null) container = new Sprite();
            
            var w:Number, h:Number;
            
            if(button == null)
            {
                
                w = lb.width + MARGIN + MARGIN;
                h = lb.height + MARGIN + MARGIN;
				
				if(totoro.width > lb.width)
				{
					totoro.scaleX = lb.width / totoro.width;
					totoro.scaleY = totoro.scaleX;
				}
				
				totoro.x = - totoro.width/2;
				totoro.y = - h/2 - totoro.height + 4;
				container.addChild(totoro);
				
                
                if(bg == null) bg = new SimpleDialogBg();
                bg.width = w;
                bg.height = h;
                container.addChild(bg);
                
                lb.x = -lb.width/2;
                lb.y = -lb.height/2;
                container.addChild(lb);
                
            }
            else 
            {
                w = Math.max(lb.width, button.width) + MARGIN * 2;
                h = MARGIN + lb.height + SPACE + button.height + MARGIN;
                
				if(totoro.width > Math.max(lb.width, button.width))
				{
					totoro.scaleX = Math.max(lb.width, button.width) / totoro.width;
					totoro.scaleY = totoro.scaleX;
				}
				
				totoro.x = - totoro.width/2;
				totoro.y = - h/2 - totoro.height + 4;
				container.addChild(totoro);
                
                if(bg == null) bg = new SimpleDialogBg();
                bg.width = w;
                bg.height = h;
                container.addChild(bg);
                
                lb.x = -lb.width/2;
                lb.y = -h/2 + MARGIN;
                container.addChild(lb);
                
                button.x = -button.width / 2;
                button.y = -h/2 + MARGIN + lb.height + SPACE;
                container.addChild(button);
                
            }
            
            if(TotoroDialog.isCenter){
                container.x = context.stage.stageWidth / 2;
                container.y = context.stage.stageHeight / 2;
            } else {
                
                var tmpX:Number = Math.max(basisX, DEF_X);
				var tmpY:Number = Math.max(basisY, DEF_Y);
                
                for(var i:int=0; i< TotoroDialog.dialogArray.length; i++){
					//모션때문에 잠깐 스케일 변경
					var tsx:Number = dialogArray[i].container.scaleX;
					var tsy:Number = dialogArray[i].container.scaleY;
					dialogArray[i].container.scaleX = 1;
					dialogArray[i].container.scaleY = 1;
					
                    dialogArray[i].x = tmpX + dialogArray[i].width / 2;
					
					dialogArray[i].container.scaleX = tsx;
					dialogArray[i].container.scaleY = tsy;
					
                    if(i==0){
                        dialogArray[i].y = tmpY;
                    } else {
						//모션때문에 잠깐 스케일 변경
						var tsx2:Number = dialogArray[i-1].container.scaleX;
						var tsy2:Number = dialogArray[i-1].container.scaleY;
						dialogArray[i-1].container.scaleX = 1;
						dialogArray[i-1].container.scaleY = 1;
						
                        dialogArray[i].y = dialogArray[i-1].y + 
							(dialogArray[i-1].height - dialogArray[i-1].totoro.height)/2 + 
							(dialogArray[i].height - dialogArray[i].totoro.height)/2 + 5;
						
						dialogArray[i-1].container.scaleX = tsx2;
						dialogArray[i-1].container.scaleY = tsy2;
                    }
                }
            }
            
            
            
            if(context.stage != null)
            {
                if(TotoroDialog.isDim){
                    dimShape = new Sprite();
                    dimShape.graphics.beginFill(0);
                    dimShape.graphics.drawRect(0,0,context.stage.stageWidth, context.stage.stageHeight);
                    dimShape.graphics.endFill();
                    dimShape.alpha = 0.0;
                    context.stage.addChild(dimShape);
					
					SooTween.alphaTo(dimShape, 0.3, 1, null, null,null, {delay:0.3});
                }
				
				container.scaleX = 0;
				container.scaleY = 0;
				
                context.stage.addChild(container);
				
				SooTween.sizeTo(container, 1, 1, 0.5, Cubic.easeOut);
            }
            
            return this;
        }
        
        /**
         * 다이어로그를 없앤다. 
         * 
         */
        public function hide():void{
            isViewing = false;
            if(isHideAfter){
                clearTimeout(timeId);
            }
            container.removeChild(bg);
            container.removeChild(lb);
			container.removeChild(totoro);
			totoro.bitmapData.dispose();
			
            if(button != null){
                container.removeChild(button);
                button.removeEventListener(MouseEvent.CLICK, onClick);
            }
            
            if(context.stage != null && context.stage.contains(container))
            {
                if(dimShape != null && context.stage.contains(dimShape)){
                    context.stage.removeChild(dimShape);
                }
                context.stage.removeChild(container);
            }
            
            for(var i:int =0; i<dialogArray.length; i++){
                if(dialogArray[i].id == this.id){
                    dialogArray.splice(i,1);
                    break;
                }
            }
        }
        
        /**
         * 모든 다이어로그를 없앤다. 
         * 
         */
        public static function hideAll():void {
            for each(var dialog:TotoroDialog in dialogArray){
                dialog.hide();
            }
        }
        
        /**
         * 다이어로그를 만들고 화면에 표시한다. 
         * @param context 다이어로그를 표시할 스테이지의 컨텍스트
         * @param message 다이어로그 메시지
         * @param isHideAfter 자동으로 사라지게 할지 여부
         * @param time 자동으로 사라지는 시간 (밀리세컨드)
         * @return CopyofEasyDialog 객체
         * 
         */
        public static function show(context:DisplayObject, message:String,isHideAfter:Boolean = true, time:int = 3000):TotoroDialog {
            return TotoroDialog.create(context, message, isHideAfter, time).show();
        }
        
        /**
         * 다이어로그를 만든다. 
         * @param context 다이어로그를 표시할 스테이지의 컨텍스트
         * @param message 다이어로그 메시지
         * @param isHideAfter 자동으로 사라지게 할지 여부
         * @param time 자동으로 사라지는 시간 (밀리세컨드)
         * @return CopyofEasyDialog 객체
         * 
         */
        public static function create(context:DisplayObject, message:String,isHideAfter:Boolean = true, time:int = 3000):TotoroDialog{
            
            var fm:TextFormat = new TextFormat("Lucida Grande", 14, 0xffffff);
            fm.bold = true;
            var dialog:TotoroDialog = new TotoroDialog();
            
            dialog.context = context;
            dialog.isViewing = false;
            dialog.lb.defaultTextFormat = fm;
            dialog.lb.mouseEnabled = false;
            dialog.lb.autoSize = TextFieldAutoSize.LEFT;
            dialog.lb.alpha = 0.7;
            dialog.lb.text = message;
            dialog.isHideAfter = isHideAfter;
            dialog.alertTime = time;
            
            return dialog;
            
        }
    }
}