package hansune.ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.formats.TextAlign;
	
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
			button.x = button.width / 2;
			button.y = button.height / 2;
			addChildAt(button,0);
			
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;

import hansune.assets.TestButtonBgDown;
import hansune.assets.TestButtonBgOver;
import hansune.assets.TestButtonBgUp;

internal class CustomSimpleButton extends SimpleButton {
	
    public function CustomSimpleButton(w:Number = 80, h:Number = 20) {
		var shape:DisplayObject = new TestButtonBgDown();
		shape.width = w;
		shape.height = h;
        downState = shape;
        
		shape = new TestButtonBgOver();
		shape.width = w;
		shape.height = h;
		overState = shape;
        
		shape = new TestButtonBgUp();
		shape.width = w;
		shape.height = h;
		upState = shape;
		
		shape = new TestButtonBgDown();
		shape.width = w;
		shape.height = h;
        hitTestState = shape;
        useHandCursor = true;
    }
}