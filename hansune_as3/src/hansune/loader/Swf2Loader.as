package hansune.loader
{	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import hansune.Hansune;
	import hansune.motion.SooTween;
	import hansune.motion.easing.Cubic;
	import hansune.motion.easing.Linear;
	
	/**
	 * ...
	 * @author hansoo
	 */
	
	/**
	 * 트랜지션이 시작될 때 
	 */
	[Event(name="change", type="flash.events.Event")]
	/**
	 *ioError 
	 */
	[Event(name="ioError", type="flash.events.Event")]
	/**
	 * 트랜지션이 끝났을 때 
	 */
	[Event(name="complete", type="flash.events.Event")]
	public class Swf2Loader extends Sprite
	{
		private var loaderA:Loader;
		private var loaderB:Loader;
		private var currentLoaderName:String;
		private var isLoading:Boolean;
		private var content:Object;
		private var isfirstLoad:Boolean;
		
		private var maskShape:Shape;
		private var isTrans:Boolean = false;
		
		public var isSmoothAtFirst:Boolean = false;
		public var isStopAtTransition:Boolean = false;
		
		public function transitioning():Boolean {
			return isTrans;
		}
		
		/**
		 * 화면전환 시간 (초) 기본 : 1.0
		 */
		public var transitionSpeed:Number = 1.0;
		
		public function Swf2Loader() 
		{
			Hansune.copyright();
			
			loaderA = new Loader();
			loaderB = new Loader();
			
			addChild(loaderA);
			addChild(loaderB);
			
			maskShape = new Shape();
			maskShape.graphics.beginFill(0);
			maskShape.graphics.drawRect(maskRect.x, maskRect.y, maskRect.width, maskRect.height);
			maskShape.graphics.endFill();
			
			
			currentLoaderName = "b";
			isLoading = false;
			isfirstLoad = true;
		}
		
		private var maskRect:Rectangle = new Rectangle(0,0,1024,768);
		public function setMaskSize(rect:Rectangle):void {
			
			maskRect.x = rect.x;
			maskRect.y = rect.y;
			maskRect.width = rect.width;
			maskRect.height = rect.height;
			
			maskShape.graphics.beginFill(0);
			maskShape.graphics.drawRect(maskRect.x, maskRect.y, maskRect.width, maskRect.height);
			maskShape.graphics.endFill();
		}
		
		private var isSmooth:Boolean = false;
		public function load(url:String, smooth:Boolean = false):void {
			
			if(isTrans) return;
			isTrans = true;
			
			isSmooth = smooth;
			
			var loader:Loader;
			if (!isLoading) {
				isLoading = true;
				if (currentLoaderName == "b") {
					loader = loaderA;
					currentLoaderName = "a";
				} else {
					loader = loaderB;
					currentLoaderName = "b";
				}
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErr);
				loader.load(new URLRequest(url));
				
			}
			
		}
		
		/**
		 * loader의 컨텐츠  
		 * @return 
		 * 
		 */
		public function getContent():Object {
			return content;
		}
		
		
		private function onLoad(e:Event):void {
			
			if (isSmooth) {
				transitionSmooth(e);
			} else {
				cutOff(e);
			}
		}
		
		private function transitionSmooth(e:Event):void {
			if (currentLoaderName == "a") {
				addChild(loaderB);
				if(loaderA.content is MovieClip){
					if(isStopAtTransition) {
						(loaderA.content as MovieClip).stop();
					} else {
						(loaderA.content as MovieClip).play();
					}
				}
				loaderA.visible = true;
				content = loaderA.content;
				
				if (isfirstLoad) {
					isfirstLoad = false;
					//if(loaderA.content is MovieClip && isStopAtTransition) (loaderA.content as MovieClip).stop();
					if(isSmoothAtFirst)
					{
						loaderA.alpha = 0;
						SooTween.alphaTo(loaderA, 1, transitionSpeed, Linear.easeOut);
					}
					isTrans = false;
					dispatchEvent(new Event(Event.COMPLETE));
					
				} else {
					dispatchEvent(new Event(Event.CHANGE));
					if(loaderB.content is MovieClip && isStopAtTransition) (loaderB.content as MovieClip).stop();
					SooTween.alphaTo(loaderB, 0, transitionSpeed, Linear.easeOut, visibleOff, "loaderB");
				}
				
			} else {
				addChild(loaderA);
				if(loaderB.content is MovieClip) {
					if(isStopAtTransition) {
						(loaderB.content as MovieClip).stop();
					} else {
						(loaderB.content as MovieClip).play();
					}
				}
				loaderB.visible = true;
				content = loaderB.content;
				dispatchEvent(new Event(Event.CHANGE));
				if(loaderA.content is MovieClip && isStopAtTransition) (loaderA.content as MovieClip).stop();
				SooTween.alphaTo(loaderA, 0, transitionSpeed, Linear.easeOut, visibleOff, "loaderA");
				
			}
			
			content.mask = maskShape;
			addChild(maskShape);
			
			isLoading = false;
		}
		
		private function visibleOff(which:String):void {
			
			if(which == "loaderA"){
				loaderA.visible = false;
				loaderA.alpha = 1.0;
				loaderA.unloadAndStop();
				
				//if(loaderB.content is MovieClip && isStopAtTransition) (loaderB.content as MovieClip).play();
			} else {
				loaderB.visible = false;
				loaderB.alpha = 1.0;
				loaderB.unloadAndStop();
				
				//if(loaderA.content is MovieClip && isStopAtTransition) (loaderA.content as MovieClip).play();
			}
			
			isTrans = false;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function cutOff(e:Event):void
		{
			
			if (currentLoaderName == "a") {
				loaderA.visible = true;
				loaderB.visible = false;
				content = loaderA.content;
				if (isfirstLoad) {
					isfirstLoad = false;
				} else {
					loaderB.unloadAndStop();
				}
			} else {
				content = loaderB.content;
				loaderA.visible = false;
				loaderA.unloadAndStop();
				loaderB.visible = true;
			}
			
			content.mask = maskShape;
			addChild(maskShape);
			
			dispatchEvent(new Event(Event.COMPLETE));
			isLoading = false;
			isTrans = false;
			
		}
		
		private function _ioErr(e:IOErrorEvent):void {
			trace("Loader IO error");
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, _ioErr);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.text));
			isTrans = false;
		}
		
	}
}

