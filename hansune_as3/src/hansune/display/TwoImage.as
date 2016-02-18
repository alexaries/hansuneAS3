package hansune.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	
	import hansune.motion.SooTween;
	
	public class TwoImage extends Sprite{
		
		public var index:uint;
		
		/**
		 * 현재 보이는 이미지의 가로 길이, 기본 image1.width; 
		 * @return 
		 * 
		 */
		override public function get width():Number {
			if(contains(image1)) return image1.width;
			if(contains(image2)) return image2.width;
			return image1.width;
		}
		/**
		 * 현재 보이는 이미지의 세로 길이, 기본 image1.height;
		 * @return 
		 * 
		 */
		override public function get height():Number {
			if(contains(image1)) return image1.height;
			if(contains(image2)) return image2.height;
			return image1.height;
		}
		
		
		protected var image1:Bitmap;
		protected var image2:Bitmap;
		protected var mouseArea:Shape;
		
		protected var shineEff:Shape;
		private var _shininig:Boolean = false;
		private var shiningTween:SooTween;
		
		/**
		 * 샤이닝 효과주기 
		 * @param value
		 * 
		 */
		public function set shining(value:Boolean):void {
			if(value){
				if(shiningTween == null) {
					shiningTween = SooTween.alphaTo(shineEff, 0, 0.4, null, null, null, {repeat:-1, yoyo:true});
				}
				shiningTween.resume();
				addChild(shineEff);
				addChild(mouseArea);
				
			} else {
				if(shiningTween != null) {
					shiningTween.pause();
					if(contains(shineEff))removeChild(shineEff);
				}
			}
			_shininig = value;
		}
		
		/**
		 * 2개의 이미지를 담아서 선택적으로 보여줌. 기본 1번이미지가 보임.
		 * @param bmd_1
		 * @param bmd_2
		 * 
		 */
		public function TwoImage(bmd_1:BitmapData, bmd_2:BitmapData) {
			image1 = new Bitmap(bmd_1);
			image2 = new Bitmap(bmd_2);
			addChild(image1);
			
			shineEff = new Shape();
			shineEff.graphics.beginFill(0xffffff,0.5);
			shineEff.graphics.drawRect(5, 5, image1.width - 5, image1.height - 5);
			shineEff.graphics.endFill();
			
			var filter:BlurFilter = new BlurFilter(10,10,1);
			shineEff.filters = [filter];
			shineEff.blendMode = BlendMode.ADD;
			shining = _shininig;
			
			mouseArea = new Shape();
			mouseArea.graphics.beginFill(0,1);
			mouseArea.graphics.drawRect(0, 0, image1.width, image1.height);
			mouseArea.graphics.endFill();
			mouseArea.alpha = 0;
			addChild(mouseArea);
		}
		
		protected var _current:uint = 1;
		public function set current(value:uint):void {
			if(_current == value) return;
			_current = value;
			if(value == 1){
				to1();
			} else {
				to2();
			}
		}
		
		public function get current():uint {
			return _current;
		}
		
		private function to2() : void {
			if(contains(image1)) removeChild(image1);
			addChild(image2);
		}
		
		private function to1() : void {
			if(contains(image2)) removeChild(image2);
			addChild(image1);
		}
		
	}
}