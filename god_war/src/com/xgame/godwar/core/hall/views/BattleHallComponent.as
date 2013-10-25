package com.xgame.godwar.core.hall.views
{
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleHallComponent extends Component
	{
		private var btnQuick: CaptionButton;
		private var btnCard: CaptionButton;
		private var btnClose: Button;
		private var scrollList: ScrollBar;
		private var roomListContainer: Container;
		
		public function BattleHallComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.hall.BattleHallComponent", null, false) as DisplayObjectContainer);
			
			btnQuick = getUI(CaptionButton, "btnQuick") as CaptionButton;
			btnCard = getUI(CaptionButton, "btnCard") as CaptionButton;
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
		}
		
		public function addRooms(list: Vector.<RoomListItemParameter>): void
		{
			var item: BattleRoomListItemComponent;
			for(var i: int = 0; i<list.length; i++)
			{
				item = new BattleRoomListItemComponent();
				item.info = list[i];
				roomListContainer.add(item);
			}
			roomListContainer.layout.update();
			scrollList.rebuild();
		}
		
		public function addRoom(item: BattleRoomListItemComponent): void
		{
			roomListContainer.add(item);
			roomListContainer.layout.update();
			scrollList.rebuild();
		}
	}
}