package hansune.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import hansune.Hansune;
	
	/**
	 * 간단히 사용할 버튼임 
	 * @author hyonsoohan
	 * 
	 */
	public class TestButton extends Sprite
	{
		private var tfield:TextField;
		private var button:CustomSimpleButton;
		
		public function get label():String {
			return tfield.text;
		}
		
		/**
		 * TestButton 생성자 
		 * @param label 버튼에 쓰여질 글자
		 * 
		 */
		public function TestButton(label:String)
		{
			Hansune.copyright();
			
			var fm:TextFormat = new TextFormat("Lucida Grande", 14, 0x000000);
			
			tfield = new TextField();
			tfield.defaultTextFormat = fm;
			tfield.textColor = 0x000000;
			tfield.autoSize = TextFieldAutoSize.LEFT;
			tfield.text = label;
			tfield.selectable = false;
			tfield.mouseEnabled =false;
			addChild(tfield);
			tfield.x = 5;
			tfield.y = 3;
			 
			button = new CustomSimpleButton(tfield.width + 10, tfield.height + 6);
			addChildAt(button,0);
			
		}
	}
}

import flash.display.Shape;
import flash.display.SimpleButton;

internal class CustomSimpleButton extends SimpleButton {
	
    public function CustomSimpleButton(w:Number = 80, h:Number = 20) {
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x999999);
		shape.graphics.drawRect(0,0,w,h);
		shape.graphics.endFill();
        downState = shape;
        
		shape = new Shape();
		shape.graphics.beginFill(0xafafaf);
		shape.graphics.drawRect(0,0,w,h);
		shape.graphics.endFill();
		overState = shape;
        
		shape = new Shape();
		shape.graphics.beginFill(0xffffff);
		shape.graphics.drawRect(0,0,w,h);
		shape.graphics.endFill();
		upState = shape;
		
		shape = new Shape();
		shape.graphics.beginFill(0xafafaf);
		shape.graphics.drawRect(0,0,w,h);
		shape.graphics.endFill();
        hitTestState = shape;
        useHandCursor = true;
    }
}