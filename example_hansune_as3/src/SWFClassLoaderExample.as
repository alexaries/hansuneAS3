
package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    
    import hansune.loader.SWFClassLoader;
	
    public class SWFClassLoaderExample extends Sprite {
        private var loader:SWFClassLoader;
        private var tf:TextField = new TextField();
        public function SWFClassLoaderExample() {
            addChild(tf);
            loader = new SWFClassLoader();
            loader.addEventListener(SWFClassLoader.LOAD_ERROR,loadErrorHandler);
            loader.addEventListener(SWFClassLoader.CLASS_LOADED,classLoadedHandler);
            loader.addEventListener(SWFClassLoader.ILLEGAL,illegalErr);
            loader.load("stringUtilsEx.swf");
        }
        private function loadErrorHandler(e:Event):void {
            tf.text = "Load failed";
            throw new Error("Cannot load the specified file.");
        }
        private function classLoadedHandler(e:Event):void {
            var runtimeClassRef:Class = loader.getClass("A");
            if(runtimeClassRef == null) return;
            
            var greeter:Object = new runtimeClassRef();
            tf.text = greeter.greet();
        }
        
        private function illegalErr(e:Event):void
        {
        	 tf.text = "illegal err";
        }
    }
}