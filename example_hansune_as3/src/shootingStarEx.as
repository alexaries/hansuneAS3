package
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import hansune.effects.ShootingStar;
	import hansune.effects.StarShape;
	
	
	[SWF(width='1024',height='768', backgroundColor='#3399FF',frameRate='60')] 
	public class shootingStarEx extends Sprite
	{
		
		private var stars:Vector.<ShootingStar>;
		private var sessionID:int = 0;
		
		public function shootingStarEx()
		{
			super();
			stars = new Vector.<ShootingStar>();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, reset);
			
			stage.doubleClickEnabled = true;
		}
		
		private function onDown(e:MouseEvent):void{
			addTuioCursor(e);
		}
		
		private function onMove(e:MouseEvent):void{
			updateTuioCursor(e);
		}
		
		private function onUp(e:MouseEvent):void {
			removeTuioCursor(e);
		}
		
		public function reset(e:MouseEvent):void {
			for each(var star:ShootingStar in stars){
				star.finish();
			}
		}
		
		public function addTuioCursor(e:MouseEvent):void
		{
			if(stage == null) return;
			
			sessionID = getTimer();
			/*var star:ShootingStar = new ShootingStar(30, ShootingStar.EMMIT_WANDER);
			star.x = e.stageX;
			star.y = e.stageY;
			star.size = 10;
			star.sizeAtStart = 0;
			star.sizeDizz = 3;
			star.rotationSpeed = 2;
			star.sessionId = sessionID;
			star.shootingInterval = 50;
			star.isFinishInIdle = false;
			star.blendMode = BlendMode.ADD;
			star.glowSize = 4;
			star.addEventListener(Event.COMPLETE, onCompStar);
			*/
			
			var star:ShootingStar = new ShootingStar(100, ShootingStar.EMMIT_WANDER);
			star.x = e.stageX;
			star.y = e.stageY;
			star.sessionId = sessionID;
			star.starColor = 0xffffff;
			star.glowColor = 0x25f7ff;
			star.glowSize = 4;
			star.size = 4;
			star.sizeDizz = 2;
			star.blendMode = BlendMode.ADD;
			
			star.alphaAtStart = 0.3;
			star.alphaDizzAtStart = 0.2;
			star.alphaAtFinish = 0.0;
			star.alphaDizzAtFinish = 0.2;
			star.wanderAreaType = ShootingStar.EMMIT_AREA_CIRCLE;
			star.wanderArea = 70;
			star.isFinishInIdle = false;
			star.shootingInterval = 100;
			star.starType = StarShape.STAR;
			star.addEventListener(Event.COMPLETE, onCompStar);
			
			
			
			
			
			stars.push(star);
			this.addChild(star)
			star.init();
		}
		
		public function updateTuioCursor(e:MouseEvent):void
		{
			if(stage == null) return;
			for each(var star:ShootingStar in stars){
				if(star.sessionId == sessionID){
					star.x = e.stageX;
					star.y = e.stageY;
				}
			}
		}
		
		public function removeTuioCursor(e:MouseEvent):void
		{
			var i:int = 0;
			for each(var star:ShootingStar in stars) {
				if(star.sessionId == sessionID){
					star.finish();
					stars.splice(i,1);
					break;
				}
				i++;
			}
		}
		
		private function onCompStar(e:Event):void {
			var star:ShootingStar = e.currentTarget as ShootingStar;
			if(this.contains(star)) removeChild(star);
			trace("comp", numChildren);
		}
	}
}