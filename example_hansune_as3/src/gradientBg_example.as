package
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import hansune.motion.easing.Strong;
	import hansune.sets.GradientBg;
	
	[SWF(width="800", height="600")]
	public class gradientBg_example extends Sprite
	{		
		public function gradientBg_example()
		{
			super();
			setTimeout(view, 500);
		}
		
		function view():void {
			var viewW = 800;
			var viewH = 600;
			var leftRect = new Rectangle(0, 0, 0, viewH);
			var finRect = new Rectangle(0, 0, viewW, viewH);
			var bg:GradientBg = new GradientBg(leftRect, finRect);
			bg.setGradient(GradientType.LINEAR, 0x000000, 0xffffff, 1, 1);
			bg.draw(1.4, Strong.easeOut);
			addChild(bg);
		}
	}
}