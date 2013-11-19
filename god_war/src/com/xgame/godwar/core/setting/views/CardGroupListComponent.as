package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class CardGroupListComponent extends Component
	{
		private var lblTitle: Label;
		private var scrollList: ScrollBar;
		private var cardGroupListContainer: Container;
		private var btnAddGroup: Button;
		private var btnDeleteGroup: Button;
		
		public function CardGroupListComponent(_skin: DisplayObjectContainer = null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CardGroupListComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			btnAddGroup = getUI(Button, "btnAddGroup") as Button;
			btnDeleteGroup = getUI(Button, "btnDeleteGroup") as Button;
			
			cardGroupListContainer = new Container();
			cardGroupListContainer.x = 23;
			cardGroupListContainer.y = 70;
			cardGroupListContainer.contentWidth = 150;
			cardGroupListContainer.contentHeight = 126;
			cardGroupListContainer.layout = new HorizontalTileLayout(cardGroupListContainer);
			addChild(cardGroupListContainer);
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = cardGroupListContainer;
			
			sortChildIndex();
			addChild(scrollList);
		}
	}
}