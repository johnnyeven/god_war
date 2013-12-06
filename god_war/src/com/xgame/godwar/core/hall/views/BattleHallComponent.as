package com.xgame.godwar.core.hall.views
{
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.events.BattleHallEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class BattleHallComponent extends Component
	{
		private var btnQuick: CaptionButton;
		private var btnCard: CaptionButton;
		private var btnCreate: CaptionButton;
		private var btnClose: Button;
		private var scrollList: ScrollBar;
		private var roomListContainer: Container;
		
		public function BattleHallComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.hall.BattleHallComponent", null, false) as DisplayObjectContainer);
			
			btnQuick = getUI(CaptionButton, "btnQuick") as CaptionButton;
			btnCard = getUI(CaptionButton, "btnCard") as CaptionButton;
			btnCreate = getUI(CaptionButton, "btnCreate") as CaptionButton;
			btnClose = getUI(Button, "btnClose") as Button;
			
			roomListContainer = new Container();
			roomListContainer.x = 39;
			roomListContainer.y = 81;
			roomListContainer.contentWidth = 469;
			roomListContainer.contentHeight = 385;
			roomListContainer.layout = new HorizontalTileLayout(roomListContainer);
			addChild(roomListContainer);
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = roomListContainer;
			
			sortChildIndex();
			addChild(scrollList);
			
			btnCreate.addEventListener(MouseEvent.CLICK, onBtnCreateClick);
			btnCard.addEventListener(MouseEvent.CLICK, onBtnCardClick);
		}
		
		public function addRooms(list: Vector.<RoomListItemParameter>): void
		{
			var item: BattleRoomListItemComponent;
			for(var i: int = 0; i<list.length; i++)
			{
				item = new BattleRoomListItemComponent();
				item.info = list[i];
				roomListContainer.add(item);
				item.doubleClickEnabled = true;
				item.addEventListener(MouseEvent.DOUBLE_CLICK, onItemClick);
			}
			roomListContainer.layout.update();
			scrollList.rebuild();
		}
		
		public function addRoom(item: BattleRoomListItemComponent): void
		{
			item.doubleClickEnabled = true;
			item.addEventListener(MouseEvent.DOUBLE_CLICK, onItemClick);
			roomListContainer.add(item);
			roomListContainer.layout.update();
			scrollList.rebuild();
		}
		
		private function onBtnCreateClick(evt: MouseEvent): void
		{
			dispatchEvent(new BattleHallEvent(BattleHallEvent.CREATE_ROOM_CLICK));
		}
		
		private function onBtnCardClick(evt: MouseEvent): void
		{
			dispatchEvent(new BattleHallEvent(BattleHallEvent.CARD_CONFIG_CLICK));
		}
		
		private function onItemClick(evt: MouseEvent): void
		{
			var event: BattleHallEvent = new BattleHallEvent(BattleHallEvent.ROOM_CLICK);
			event.param = evt.currentTarget;
			dispatchEvent(event);
		}
	}
}