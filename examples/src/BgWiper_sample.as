package {

import flash.display.Sprite;
import flash.events.Event;

import hansune.display.BgWiper;

[SWF(width="400", height="400", backgroundColor="#000000", frameRate="50")]

public class BgWiper_sample extends Sprite {

    private var bg:BgWiper;

    public function BgWiper_sample() {
        bg = new BgWiper(400, 400);
        this.addChild(bg);
        bg.addEventListener(Event.CHANGE, onImageChanged);
        bg.load("data/kim.jpg", 0.3, BgWiper.UP);
    }

    private function onImageChanged(e:Event):void {
        trace("image changed");
    }
}
}