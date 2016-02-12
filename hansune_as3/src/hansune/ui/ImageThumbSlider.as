package hansune.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import hansune.Hansune;
	import hansune.ui.ImageThumbSliderItem;
	
	/**
	 * 아이템 선택시 아이템 id 전달
	 */
	[Event(name="data", type="flash.events.DataEvent")]
	
	/**
	 * 순환형 이미지 슬라이더이다. 
	 * @author hanhyonsoo
	 * 
	 */
	public class ImageThumbSlider extends Sprite
	{
		
		private var items:Vector.<ImageThumbSliderItem>;//원본 아이템을 갖고 있는 배열
		private var recycleItems:Array = [];//재사용성을 위한 아이템 배열
		
		private var ques:Array = [];//파일 로드를 위한 배열 
		private var _itemViewRect:Rectangle;//아이템 이미지의 보여지는 영역지정. SliderItem.viewRect 값을 일괄설정하게 됨.
		private var viewRect:Rectangle;//슬라이더의 보여지는 영역, 가로 세로 길이만 참조하여 전체 마스크 설정함.
		private var viewMask:Shape;//슬라이더 마스크용
		private var itemsBox:Sprite;//아이템들의 부모 디스플레이 리스트 
		
		/**
		 * 아이템의 간격
		 */
		public var itemSpan:Number = 0;
		
		/**
		 * 자동이동 여부
		 */
		public var isAutoFlow:Boolean = true;
		
		/**
		 * 스냅여부
		 */
		public var snaping:Boolean = true;
		
		private var auto:Boolean = false; //자동이동을 위한 변수
		private var autoid:Number; //자동 이동을 위한 변수
		
		private var _snapTime:Number = 3000;//스냅 이동 시간 간격
		private var snapNow:int = 0;//스냅이 이루어진 시기
		/**
		 *  순환형 이미지 슬라이더 생성자.
		 * @param viewWidth
		 * @param viewHeight
		 * 
		 */
		public function ImageThumbSlider(viewWidth:Number = 600, viewHeight:Number = 200)
		{
			super();
			viewRect = new Rectangle(0, 0, viewWidth, viewHeight);
			Hansune.copyright();
		}
		
		/**
		 * 스냅 이동 시간 간격
		 * @return millisecond
		 * 
		 */
		public function get snapTime():Number
		{
			return _snapTime;
		}

		/**
		 * 스냅 이동 시간 간격
		 * @param value millisecond
		 * 
		 */
		public function set snapTime(value:Number):void
		{
			_snapTime = value;
		}

		private function buildUnits():void {
			if(items != null) return;
			items = new Vector.<ImageThumbSliderItem>();
			viewMask = new Shape();
			viewMask.graphics.beginFill(0);
			viewMask.graphics.drawRect(0, 0, viewRect.width, viewRect.height);
			viewMask.graphics.endFill();
			itemsBox = new Sprite();
			
			addChild(itemsBox);
			addChild(viewMask);
			itemsBox.mask = viewMask;
		}
		
		
		/**
		 * 이미지 아이템의 뷰 영역(SliderItem.viewRect)을 설정한다.  
		 * @param value
		 * 
		 */
		public function set itemViewRect(value:Rectangle):void
		{
			_itemViewRect = value;
		}

		/**
		 * 배치 로드 배열에 파일 경로 추가<br>
		 * Queuing file up for loading image file.
		 * @param path
		 */
		public function addQueFile(path:String):void {
			ques.push(path);
		}
		
		/**
		 * 배치 로드 배열에 파일 경로 배열을 추가<br>
		 * Queuing up the file arrays  for loading image file.
		 * @param paths
		 * @param ids
		 */
		public function addQueFileArray(paths:Array):void {
			ques = ques.concat(paths);
		}
		
		/**
		 * 배치 배열에 있는 이미지를 로드한다.
		 * Load images in the queue.
		 */
		public function runQue():void {
			buildUnits();
			cnt = 0;
			startLoadQue();
		}
		
		/**
		 * 이미지 파일을 뷰리스트에 추가한다.
		 * @param path 뷰리스트에 추가할 파일경로
		 * @param at 추가할 위치
		 * 
		 */
		public function addFile(path:String, at:int = -1):void {
			//TODO 추가 예정
		}
		
		
		/**
		 *  SliderItem을 뷰리스트에 추가한다.<br>
		 * Add a SliderItem to the viewlist
		 * @param item
		 * @param at 추가할 위치
		 */
		public function addSliderItem(item:ImageThumbSliderItem, at:int = -1):void {
			//TODO 추가 예정
		}
		
		/**
		 * Release containing items.
		 * 포함하고 있는 요소들의 연결을 해제 시킨다.
		 */
		public function release():void {
			if(contains(itemsBox)) removeChild(itemsBox);
			initialMotion = false;
			itemsBox.removeEventListener(MouseEvent.MOUSE_DOWN, onDownSlider);
			itemsBox.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveSlider);
			itemsBox.removeEventListener(MouseEvent.MOUSE_OUT, onOutSlider);
			itemsBox.removeEventListener(MouseEvent.MOUSE_UP, onOutSlider);
			
			var ix:int = 0;
			var il:int = itemsBox.numChildren;
			for(ix=0; ix < il; ix++) {
				itemsBox.getChildAt(0).removeEventListener(MouseEvent.CLICK, onClickItem);
				itemsBox.removeChildAt(0);
			}
			removeEventListener(Event.ENTER_FRAME, onRender);
			
			il = items.length;
			for(ix=0; ix < il; ix++) {
				items[ix].removeEventListener(MouseEvent.CLICK, onClickItem);
			}
			
			items = new Vector.<ImageThumbSliderItem>();
		}
		
		
		/**
		 *  파일 로딩 부분
		 * 
		 * */
		
		
		private var cnt:int = 0;//로딩 카운트
		private var interval:int = 0;
		private var initialMotion:Boolean = false;
		
		private function startLoadQue():void {
			
			clearInterval(interval);
			var ix:int = 0;
			var il:int = itemsBox.numChildren;
			for(ix=0; ix < il; ix++) {
				itemsBox.getChildAt(ix).removeEventListener(MouseEvent.MOUSE_UP, onClickItem);
			}
			itemsBox.removeChildren();
			
			cnt = 0;
			interval = setInterval(onLoad, 30);
		}
		
		protected function onLoad():void
		{
			var item:ImageThumbSliderItem = new ImageThumbSliderItem(ques[cnt], cnt.toString());
			item.viewRect = _itemViewRect;//아이템 뷰렉트 적용
			items.push(item);//아이템 리스트 추가
			//
			if(cnt + 1 >= ques.length) {
				clearInterval(interval);
				
				//item 앞뒤 체인 연결
				if(cnt == 0) {
					items[0].frontItem = items[items.length - 1];
					items[0].rearItem = items[1];
				}
				else if(cnt == items.length - 1) {
					items[items.length - 1].frontItem = items[items.length - 2];
					items[items.length - 1].rearItem = items[0];	
				}
				else {
					items[cnt].frontItem = items[cnt - 1];
					items[cnt].rearItem = items[cnt + 1];
				}
				
				initialMotion = true;
				setTimeout(startInteraction, 1000);//1초동안 시작 모션 보여줌.
				snapNow = getTimer();
				addEventListener(Event.ENTER_FRAME, onRender);
			}
			else {
				
				////처음 아이템 배치
				var tw:Number = (item.width + itemSpan) * cnt + item.width;//아이템 총 가로 길이
				var head:int = 0;//서칭 인덱스
				var right:Number = viewRect.width;// + items[0].width * 4;//최총 가로 길이
//				var idx:int = 0;
				if(tw < right) {
					item = items[head].clone();//아이템 복사
					
					item.tx = (item.width + itemSpan) * (cnt - 2);//아이템 타겟 지점
					item.x =  (item.width + itemSpan) * (cnt - 1);//아이템 시작 지점
					
					cnt ++;
					head ++;
					if(head >= items.length) {
						head = 0;
					}
					
					
					//item.setLabel(head.toString()); // 라벨표시
					itemsBox.addChild(item);//디스플레이 리스트에 추가
					
				} 
			}
		}
		
//		private var dx:Number = 0;
		private var px:Number = 0;//이전 x 좌표
		private var draging:Boolean = false;//드래구 중인지 여부
		private function startInteraction():void
		{
			initialMotion = false;
			itemsBox.addEventListener(MouseEvent.MOUSE_DOWN, onDownSlider);
			itemsBox.addEventListener(MouseEvent.MOUSE_MOVE, onMoveSlider);
			itemsBox.addEventListener(MouseEvent.MOUSE_OUT, onOutSlider);
			itemsBox.addEventListener(MouseEvent.MOUSE_UP, onUpSlider);
			itemsBox.graphics.beginFill(0,0);
			itemsBox.graphics.drawRect(0, 0, viewRect.width, viewRect.height);
			itemsBox.graphics.endFill();
			
			auto = true;
			
			var ix:int = 0;
			var il:int = itemsBox.numChildren;
			for(ix=0; ix < il; ix++) {
				ImageThumbSliderItem(itemsBox.getChildAt(ix)).addEventListener(MouseEvent.MOUSE_UP, onClickItem);
			}
		}
		
		public function next():void {
			
		}
		
		public function prev():void {
			
		}
		
		
		protected function onClickItem(event:MouseEvent):void
		{
			if(!draging){
				dispatchEvent(new DataEvent(DataEvent.DATA, false, false, event.currentTarget.id as String));
			}
		}
		
		protected function onUpSlider(event:MouseEvent):void
		{
			if(draging) {
				draging = false;
				clearTimeout(autoid);
				autoid = setTimeout(autotrue, 5000);
				if(snaping){
					itemsToSnapTarget();
				}
			}
		}
		
		protected function onOutSlider(event:MouseEvent):void
		{
			var local:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
			if(viewRect.contains(local.x, local.y) == false && draging) {
				draging = false;
				clearTimeout(autoid);
				autoid = setTimeout(autotrue, 5000);
				
				if(snaping){
					itemsToSnapTarget();
				}
			}
		}
		
		private function itemsToSnapTarget():void {
			var ix:int = 0;
			var il:int = itemsBox.numChildren;
			var item:ImageThumbSliderItem;
			for(ix=0; ix < il; ix++) {
				item = ImageThumbSliderItem(itemsBox.getChildAt(ix));
				item.tx = (item.width + itemSpan) * (ix - 2);//아이템 타겟 지점
			}
		}
		
		private function autotrue():void
		{
			auto = true;
			itemsToSnapTarget();
		}
		
		protected function onMoveSlider(event:MouseEvent):void
		{
			//일정범위 드래그하면 드래깅 모드
			if(Math.abs(event.stageX - px) > 10 && event.buttonDown) {
				draging = true;
				auto = false;
				clearTimeout(autoid);
			}
			
			//드래깅 모드시
			if(draging && event.buttonDown) {
				var ix:int = 0;
				var il:int = itemsBox.numChildren;
				for(ix=0; ix < il; ix++) {
					ImageThumbSliderItem(itemsBox.getChildAt(ix)).tx += (event.stageX - px);
				}
				px = event.stageX;//이전 좌표 저장
			}
		}
		
		protected function onDownSlider(event:MouseEvent):void
		{
			px = event.stageX;
			draging = false;
			auto = false;
		}		
		
		
		/**
		 * 렌더
		 * 
		 * */
		
		
		private function onRender(e:Event):void {
			var ix:int = 0;
			var il:int = itemsBox.numChildren;
			var item:ImageThumbSliderItem;
			//초기 진입 모션
			if(initialMotion) {
				for(ix=0; ix < il; ix++) {
					item = ImageThumbSliderItem(itemsBox.getChildAt(ix));
					item.x += (item.tx - item.x) * 0.2;
				}
				return;
			}
			
			if(isAutoFlow) {
				if(auto) {
					if(snaping) {
						if(getTimer() - snapNow > snapTime) { 
							snapNow = getTimer();
							for(ix=0; ix < il; ix++) {
								item = ImageThumbSliderItem(itemsBox.getChildAt(ix));
								item.tx -= (item.width + itemSpan);
							}
						}
					}
					else {
						for(ix=0; ix < il; ix++) {
							item = ImageThumbSliderItem(itemsBox.getChildAt(ix));
							item.tx -= 5;
						}
					}
				}
			}
			
			//아이템 이동
			for(ix=0; ix < il; ix++) {
				item = ImageThumbSliderItem(itemsBox.getChildAt(ix));
				item.x += (item.tx - item.x) * 0.2;
			}
			
			//가장 앞의 아이템
			var first:ImageThumbSliderItem = itemsBox.getChildAt(0) as ImageThumbSliderItem;
			//일정범위를 넘어서면 삭제
			if(first.x < - (first.width + itemSpan) * 2.5) {
				recycleItems.push(itemsBox.removeChild(first));
			}
			//처음아이템이 나타나려고 할 때 새로운 아이템을 앞에 추가
			else if(first.x > -(first.width)) {
				item = getRecyclable(first.frontItem.id);//재사용배열에서 아이템을 골라옴.
				item.x = first.x - item.width * 1.3 - itemSpan;
				item.tx = first.tx - item.width - itemSpan;
				itemsBox.addChildAt(item, 0);
			}
			//가장 뒤의 아이템
			var last:ImageThumbSliderItem = itemsBox.getChildAt(itemsBox.numChildren - 1) as ImageThumbSliderItem;
			if(last.x < viewRect.width + last.width) {
				item = getRecyclable(last.rearItem.id);
				item.x = last.x + item.width * 1.3 + itemSpan;
				item.tx = last.tx + last.width + itemSpan;
				itemsBox.addChild(item);
			}
			else if(last.x > viewRect.width + (last.width + itemSpan) * 2.5) {
				recycleItems.push(itemsBox.removeChild(last));
			}
			
		}
		
		
		//화면상에 보이는 아이템들의 재사용률을 높이기 위해 새로운 아이템이 아니면 재사용하도록 함
		private function getRecyclable(id:String):ImageThumbSliderItem {
			var item:ImageThumbSliderItem;
			for each(item in recycleItems) {
				if(item.id == id && !itemsBox.contains(item)) {
					return item;//해당 id 와 같은 사용하지 않는 아이템이 있을 경우 
				}
			}
			
			for (var i:int = 0; i < items.length; i++) 
			{
				if(items[i].id == id) {
					item = items[i].clone();//해당 아이디가 없어서 원본아이템 배열에서 복사함.
					item.addEventListener(MouseEvent.MOUSE_UP, onClickItem);
					recycleItems.push(item);
					break;
				}
			}
			
			return item;
		}
	}
}