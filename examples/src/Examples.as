package {
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="50")]

public class Examples extends Sprite {
    public function Examples() {

        this.addEventListener(Event.ADDED_TO_STAGE, onAdded)
    }

    private function onAdded(e:Event) {
        var tf:TextField = new TextField()
        tf.textColor = 0x000000
        tf.width = 400
        tf.height = 300
        tf.border = true
        tf.text = "Run each actionscript file"
        tf.setTextFormat(new TextFormat(null, 22))
        addChild(tf)

        graphics.beginFill(0xffffff)
        graphics.drawRect(0, 0, 800, 600)
        graphics.endFill()
    }
}
}
