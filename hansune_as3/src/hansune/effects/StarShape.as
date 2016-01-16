package hansune.effects
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	
	public class StarShape extends Shape 
	{
		private var _fx:Number = 0;//fixed position
		private var _fy:Number = 0;//fixed position
		
		internal var ix:Number;//x position
		internal var iy:Number;//y position
		internal var tx:Number;//target x position
		internal var ty:Number;//target y position
		internal var targetAlpha:Number;//target alpha
		internal var targetScale:Number;//target scale
		private var _color:uint = 0;//color
		internal var glow:uint;//glow distance
		internal var glowAlpha:Number = 0.2;
		internal var rotationPlus:Number = 2;//x position shift
		
		internal var distort:Number;//distort circle 1.2~1.4
		internal var speed:Number;
		
		internal var type:uint = 0;
		internal var ready:Boolean = false;
		
		public static const STAR:int = 0;
		public static const CIRCLE:int = 1;
		public static const FLOWER:int = 2;
		
		private var _innerRotation:Number = 0;//rotation
		private var ssw:Number, ssh:Number;
		private var _scale:Number;//scale
		
		public function StarShape(type:int = 0, width:Number = 10, height:Number = 10)
		{
			this.type = type;
			this.ssw = width;
			this.ssh = height;
			
			draw();
		}
		
		public function get fy():Number
		{
			return _fy;
		}

		public function set fy(value:Number):void
		{
			_fy = value;
		}

		public function get fx():Number
		{
			return _fx;
		}

		public function set fx(value:Number):void
		{
			_fx = value;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}

		public function get innerRotation():Number
		{
			return _innerRotation;
		}

		public function set innerRotation(value:Number):void
		{
			_innerRotation = value;
			draw();
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
			scaleX = _scale;
			scaleY = _scale;
		}

		public function draw():void {
			switch(type){
				case FLOWER :
					graphics.clear();
					graphics.beginFill(color,1);
					graphics.moveTo(Math.cos(Math.PI*0.25+innerRotation)*(ssw * 0.4),  Math.sin(Math.PI*0.25+innerRotation)*(ssh * 0.4));
					graphics.curveTo(Math.cos(Math.PI*0.50+innerRotation)* ssw,  Math.sin(Math.PI*0.50+innerRotation)* ssh, Math.cos(Math.PI*0.75+innerRotation)*(ssw * 0.4),  Math.sin(Math.PI*0.75+innerRotation)*(ssh * 0.4));
					graphics.curveTo(Math.cos(Math.PI*1.00+innerRotation)* ssw,  Math.sin(Math.PI*1.00+innerRotation)* ssh, Math.cos(Math.PI*1.25+innerRotation)*(ssw * 0.4),  Math.sin(Math.PI*1.25+innerRotation)*(ssh * 0.4));
					graphics.curveTo(Math.cos(Math.PI*1.50+innerRotation)* ssw,  Math.sin(Math.PI*1.50+innerRotation)* ssh, Math.cos(Math.PI*1.75+innerRotation)*(ssw * 0.4),  Math.sin(Math.PI*1.75+innerRotation)*(ssh * 0.4));
					graphics.curveTo(Math.cos(Math.PI*2.00+innerRotation)* ssw,  Math.sin(Math.PI*2.00+innerRotation)* ssh, Math.cos(Math.PI*0.25+innerRotation)*(ssw * 0.4),  Math.sin(Math.PI*0.25+innerRotation)*(ssh * 0.4));
					graphics.endFill();
					break;
				
				case STAR :
					graphics.clear();
					graphics.beginFill(color,1);
					graphics.moveTo(Math.cos(Math.PI*0.25+innerRotation)* ssw * 0.6,  Math.sin(Math.PI*0.25+innerRotation)* ssh * 0.6);
					graphics.curveTo(Math.cos(Math.PI*0.50+innerRotation)* ssw * 3,  Math.sin(Math.PI*0.50+innerRotation)* ssh * 3, Math.cos(Math.PI*0.75+innerRotation)*(ssw * 0.6),  Math.sin(Math.PI*0.75+innerRotation)*(ssh * 0.6));
					graphics.curveTo(Math.cos(Math.PI*1.00+innerRotation)* ssw * 3,  Math.sin(Math.PI*1.00+innerRotation)* ssh * 3, Math.cos(Math.PI*1.25+innerRotation)*(ssw * 0.6),  Math.sin(Math.PI*1.25+innerRotation)*(ssh * 0.6));
					graphics.curveTo(Math.cos(Math.PI*1.50+innerRotation)* ssw * 3,  Math.sin(Math.PI*1.50+innerRotation)* ssh * 3, Math.cos(Math.PI*1.75+innerRotation)*(ssw * 0.6),  Math.sin(Math.PI*1.75+innerRotation)*(ssh * 0.6));
					graphics.curveTo(Math.cos(Math.PI*2.00+innerRotation)* ssw * 3,  Math.sin(Math.PI*2.00+innerRotation)* ssh * 3, Math.cos(Math.PI*0.25+innerRotation)*(ssw * 0.6),  Math.sin(Math.PI*0.25+innerRotation)*(ssh * 0.6));
					graphics.endFill();
					break;
				
				case CIRCLE :
					graphics.clear();
					graphics.beginFill(color,1);
					graphics.drawEllipse(0,0,ssw, ssh);
					graphics.endFill();
					break;
			}
		}
	}
}
