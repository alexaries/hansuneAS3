/*------------------------------------------------------------------------------
* NAME : SimpleTween
* DESC : SimpleTween motion class
* $Author: 한현수
* $Revision: 1.5
*------------------------------------------------------------------------------
* 수정사항
* 130125 SooTween 으로 이름 변경
* 120409 같은 ID 에 대해서 동시에 업데이트
*------------------------------------------------------------------------------
* $Log: 
* 
*----------------------------------------------------------------------------*/
//TODO  renderer를 enterframe 으로 하는 것이 맞는지 확인 
package hansune.motion
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;
    
    import hansune.motion.easing.Linear;
    
    /**
     * SimpleTween 은  가장 많이 쓰는 기본적인 트윈 기능을 갖고 있다.<br/>
     * 트윈클래스를 스터디하며 제작함.<br/>
	 * 
	 * alphaTo, sizeTo, moveTo, to 명령어로 트위닝을 적용한다.
     * 
     * @author hansoo
     * 
     */
    public class SooTween extends EventDispatcher
    {
        internal var _target:Object;
        internal var _props:Array = [];
        internal var _id:uint;
        internal var _startTime:int;//millisecond
        internal var _initials:Array = [];
        internal var _changes:Array = [];
        internal var _duration:Number;//second
        internal var _easing:Function;
        internal var _endFunction:Function;
        internal var _endParam:*;
        internal var _yoyo:Boolean = false;
        internal var _repeat:int = 0;
        internal var _count:int = 0;
        internal var _isPlaying:Boolean = true;
        internal var _isFinish:Boolean = false;
        internal var _isDispose:Boolean = false;
        internal var _covered:Number = 0;//second
        internal var _updateFunction:Function;
        internal var _delay:Number = 0;//millisecond
		internal var _visibility:int = 0;
        
        /**
         *  SimpleTween 생성자. SimpleTween 의 클래스 함수를 통해 생성한다.
         * 
         */
        public function SooTween()
        {
            super(null);
        }
        
        /**
         * 애니메이션을 주는 대상 
         * @return 
         * 
         */
        public function get target():Object { return _target;}
        
        
        /**
         * 시작 -> 끝 -> 시작으로 반복되는 yoyo 애니메이션인지 여부 확인
         * @return 
         * 
         */
        public function get isYoyo():Boolean {return _yoyo;}
        
        /**
         * 일시 정지 해제
         * 
         */
        public function resume():void {
            _isPlaying = true;
        }
        /**
         * 애니메이션 일시 정지 
         * 
         */
        public function pause():void {
            _isPlaying = false;
        }
        /**
         * 애니메이션 강제 종료
         * 애니메이션의 끝으로 변경 후 제거된다.
         */
        public function finish():void {
            _isFinish = true;
        }
        /**
         * 애니메이션 강제 제거,
         * 애니메이션 도중 멈춘 후 제거된다. 
         */
        public function dispose():void {
            _isDispose = true;
        }
        /**
         * 플레이 중인지 확인
         * @return 
         * 
         */
        public function get isPlaying():Boolean {
            return _isPlaying;
        }
        /**
         * 종료되었는지 확인
         * @return 
         * 
         */
        public function get isFinish():Boolean {
            return _isFinish;
        }
        
        /**
         * true 이면 애니메이션 상태 정보를 볼 수 있다. 
         */
        static public var debug:Boolean = false;
        
        /**
         * 모든 Simple 애니메이션을 완료시킨다. 
         * 
         */
        static public function finishAll():void {
            for(var i:int=0; i<renderlist.length; i++){
                renderlist[i].finish();
            }
        }
        
        /**
         * 모든 Simple 애니메이션을 정지시키고 없애버린다. 
         * 
         */
        static public function disposeAll():void {
			var l:int = renderlist.length;
            for(var i:int=0; i< l; i++){
                //renderlist[i].dispose();
				renderlist.pop();
				renderID.pop();
            }
        }
        
		
        private static var renderer:DisplayObject = new Sprite();
        private static var renderlist:Vector.<SooTween> = new Vector.<SooTween>();
        private static var renderID:Vector.<int> = new Vector.<int>();
        private static var r:uint = 0;
        
        /**
         * 오브젝트의 속성을 임의로 지정하여 애니메이션 효과를 준다.<br>
         * TweenMax 의 사용법과  동일하게 사용하도록 함. 가능한 속성은 x, y, z, scaleX, scaleY, alpha, rotation, visible 이다.<br>
		 * visible 이 true이면 모션 시작시 적용하고, false 이면 모션이 끝나고 적용된다.
         * @param obj
         * @param duration
         * @param options ease:Function, onComplete:Function, onCompleteParams:Array, yoyo:Boolean, repeat:int, onUpdate:Function, delay:Number
         * @return SimpleTween 객체
         * 
         */
        static public function to(obj:DisplayObject, duration:Number, options:Object):SooTween 
        {
            var __id:uint = r;
			r ++;
			if(r == uint.MAX_VALUE) r = 0;
            
            var sim:SooTween;
            var available:Array = ["x", "y",  "z", "width", "height", "scaleX", "scaleY", "alpha", "rotation"];
			var properties:Array = [];
			var targets:Array = [];
			var visibility:int = 0;
            for(var i:int=0; i<available.length; i++) {
                if(options[available[i]] != null)
                {
					properties.push(available[i]);
					targets.push(options[available[i]]);
                }
            }
			if(options.visible != null) {
				if(options.visible == true) { 
					visibility = 1;
				}
				else {
					visibility = 2;
				}
			}
			if(properties.length == 0) return null;
			sim = simpleCore(obj, properties, targets, duration, 
				options["ease"], 
				options["onComplete"], 
				options["onCompleteParams"],
				options);
			sim._id = __id;
			sim._visibility = visibility;
			renderlist.push(sim);
			renderID[renderlist.length - 1] = __id;
            
            if(debug) trace("renderlist added ID : ", __id,"prop : ", sim._props);
            renderer.addEventListener(Event.ENTER_FRAME, onProcess);
            
            return sim;
            
        }
        
        /**
         * 크기 변동
         * @param obj
         * @param toWidth
         * @param toHeight
         * @param duration
         * @param easing
         * @param endFunction
         * @param endParam
         * @param option yoyo:Boolean, repeat:int, onUpdate:Function, delay:int
         */
        static public function sizeTo(obj:DisplayObject, 
                                      toScaleX:Number, 
                                      toScaleY:Number, 
                                      duration:Number = 1, 
                                      easing:Function = null,
                                      endFunction:Function = null, 
                                      endParam:* = null,
                                      option:Object = null):SooTween 
        {
            var __id:uint = r;
			r ++;
			if(r == uint.MAX_VALUE) r = 0;
			
			var properties:Array = ["scaleX", "scaleY"];
			var targets:Array = [toScaleX, toScaleY];
			
            var sim:SooTween = simpleCore(obj, properties, targets, duration, easing, endFunction, endParam, option);
            sim._id = __id;
            renderlist.push(sim);
            renderID[renderlist.length - 1] = __id;
            
            if(debug) trace("renderlist added ID : ", __id,"prop : ", sim._props);
            renderer.addEventListener(Event.ENTER_FRAME, onProcess);
            
            return sim;
        }
        
        /**
         * 위치 이동
         * @param obj
         * @param toX
         * @param toY
         * @param duration
         * @param easing
         * @param endFunction
         * @param endParam
         * @param option yoyo:Boolean, repeat:int, onUpdate:Function, delay:int
         */
        static public function moveTo(obj:DisplayObject, 
                                      toX:Number, 
                                      toY:Number, 
                                      duration:Number = 1, 
                                      easing:Function = null,
                                      endFunction:Function = null, 
                                      endParam:* = null,
                                      option:Object = null):SooTween 
        {
            var __id:uint = r;
			r ++;
			if(r == uint.MAX_VALUE) r = 0;
			
			var properties:Array = ["x", "y"];
			var targets:Array = [toX, toY];
			
            //
            var sim:SooTween = simpleCore(obj, properties, targets, duration, easing, endFunction, endParam, option);
            sim._id = __id;
            renderlist.push(sim);
            renderID[renderlist.length - 1] = __id;
            
            if(debug) trace("renderlist added ID : ", __id,"prop : ", sim._props);
            renderer.addEventListener(Event.ENTER_FRAME, onProcess);
            
            return sim;
        }
        
        /**
         * 투명도  
         * @param obj
         * @param toAlpha
         * @param duration
         * @param easing
         * @param endFunction
         * @param param
         * @param option yoyo:Boolean, repeat:int, onUpdate:Function, delay:Number
         */
        static public function alphaTo(obj:DisplayObject, 
                                       toAlpha:Number, 
                                       duration:Number = 1, 
                                       easing:Function = null,
                                       endFunction:Function = null,
                                       endParam:* = null,
                                       option:Object = null):SooTween
        {
            var __id:uint = r;
			r++;
			if(r == uint.MAX_VALUE) r = 0;
			
			var properties:Array = ["alpha"];
			var targets:Array = [toAlpha];
			
            var sim:SooTween = simpleCore(obj, properties, targets, duration, easing, endFunction, endParam, option);
            sim._id = __id;
            renderlist.push(sim);
            renderID[renderlist.length - 1] = __id;
            
            if(debug) trace("renderlist added ID : ", __id,"prop : ", sim._props);
            renderer.addEventListener(Event.ENTER_FRAME, onProcess);
            
            return sim;
        }
        
        static private function simpleCore(obj:Object, 
                                           ofProp:Array,
                                           toValue:Array, 
                                           duration:Number = 1, 
                                           easing:Function = null,
                                           endFunction:Function = null,
                                           endParam:* = null,
                                           option:Object = null):SooTween
        {
            var sim:SooTween = new SooTween();
            sim._target = obj;
            sim._props = ofProp;
			for (var i:int = 0; i < ofProp.length; i++) 
			{
				sim._initials[i] = obj[ofProp[i]];
				sim._changes[i] = toValue[i] - obj[ofProp[i]];
			}
			sim._duration = duration;
            sim._easing = (easing == null)? Linear.easeOut : easing;
            sim._endFunction = endFunction;
            sim._endParam = endParam;
            sim._startTime = getTimer();
            if(option != null){
                sim._yoyo = (option["yoyo"] != null)? option["yoyo"]:false;
                sim._repeat = (option["repeat"] != null)? option["repeat"]:0;
                sim._updateFunction = (option["onUpdate"] != null)? option["onUpdate"]:null;
                sim._delay = (option["delay"] != null)? option["delay"]:0;
                sim._delay *= 1000;
            }
            if(sim._yoyo && sim._repeat > 0){
                sim._repeat *= 2;
            }
            
            return sim;
        }
        
        static private function onProcess(e:Event):void {
            
            if(renderlist.length < 1){
                renderer.removeEventListener(Event.ENTER_FRAME, onProcess);
                if(debug) trace("nothing to render");
                return;
            }
            
            var i:int;
            for(i=0; i<renderlist.length; i++){
                update(renderlist[i]);
            }
        }
        
		
		static private var now:int;
		static private var li:int;
        static private function update(sim:SooTween):void {
            
			if(sim._isDispose) {
				dispose(sim);
				return;
			}
			
			if(sim._isFinish){
				finish(sim);
				return;
			}
			
			
			now = getTimer();
			
            if(!sim._isPlaying) {
                sim._startTime = now - sim._covered * 1000;
                return;	
            }
            if(sim._delay > 0){
                sim._delay -= (now - sim._startTime);
                sim._startTime = now;
                return;
            }
			if(sim._visibility == 1) {
				sim._visibility = 5;
				sim._target.visible = true;
			}
            //시간계산
            sim._covered = (now - sim._startTime) * 0.001;
			//속성 변경
			for (li = 0; li < sim._props.length; li++)  {
				sim.target[sim._props[li]] = sim._easing(sim._covered, sim._initials[li], sim._changes[li], sim._duration);
			}
			//업데이트 함수 실행
            if(sim._updateFunction != null) {
                sim._updateFunction.call();
            }
            
            if (sim._covered >= sim._duration) {
                
                if(sim._yoyo){
                    if(sim._repeat <= 0 || sim._repeat > sim._count){
						for (li = 0; li < sim._props.length; li++)  {
	                        sim.target[sim._props[li]] = sim._initials[li] + sim._changes[li];
	                        sim._initials[li] += sim._changes[li]; 
	                        sim._changes[li] *= -1;
						}
                        sim._startTime = now;
                        sim._count += 1;
                        return;
                    }
                }
                
                if(sim._repeat > sim._count){
					for (li = 0; li < sim._props.length; li++)  {
                    	sim.target[sim._props[li]] = sim._initials[li];
					}
                    sim._startTime = now;
                    sim._count += 1;
                    return;
                }
                
                finish(sim);
            }
        }
        
        static private function finish(sim:SooTween):void {
            var index:int;
			var i:int;
            while(renderID.indexOf(sim._id) >= 0){
                index = renderID.indexOf(sim._id);
                renderlist.splice(index,1);
                renderID.splice(index,1);
				for (i = 0; i < sim._props.length; i++)  {
                	sim.target[sim._props[i]] = sim._initials[i] + sim._changes[i];
				}
            }
			
			if(sim._visibility == 2) {
				sim._visibility = 5;
				sim._target.visible = false;
			}
           
            if (sim._endFunction != null) {
                if (sim._endParam == null) {
                    sim._endFunction.call();
                } else {
                    if(sim._endParam is Array)
                    {
                        sim._endFunction.apply(null, sim._endParam);
                    }
                    else
                    {
                        sim._endFunction(sim._endParam);
                    }
                }
            }
            
            sim._isFinish = true;
        }
        
        static private function dispose(sim:SooTween):void {
            var index:int;
            while(renderID.indexOf(sim._id) < 0){
                index = renderID.indexOf(sim._id);
                renderlist.splice(index,1);
                renderID.splice(index,1);
            }
            sim._isFinish = true;
        }
    }
}