package {

import com.nascom.graphics.Rippler;

import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;

    [SWF(backgroundColor="0x000000", frameRate="30", width="600", height="419")]
    public class Rippler_sample extends Sprite
    {
    	// Embed an image (Flex Builder only, use library in Flash Authoring)
        [Embed(source="/data/kim.jpg")]
        private var sourceImage : Class;
        
        private var _target : Bitmap;
        private var _rippler : Rippler;
        
        public function Rippler_sample()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            // create a Bitmap displayobject and add it to the stage 
           // _target = new Bitmap(new sourceImage(600,419).clone());
          	_target = new Bitmap(new sourceImage().bitmapData);
            addChild(_target);
            
            // create the Rippler instance to affect the Bitmap object
            _rippler = new Rippler(_target, 60, 6);
            
            // create the event listener for mouse movements
            stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }
        
        // creates a ripple at mouse coordinates on mouse movement
        private function handleMouseMove(event : MouseEvent) : void
        {
        	// the ripple point of impact is size 20 and has alpha 1
            _rippler.drawRipple(_target.mouseX, _target.mouseY, 20, 1);
        }
    }
}