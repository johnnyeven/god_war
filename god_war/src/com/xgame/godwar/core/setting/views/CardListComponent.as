package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.component.Select;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class CardListComponent extends Component
	{
		private var lblTitle: Label;
		private var lblRace: Label;
		private var lblLevel: Label;
		private var btnViewSelect: Button;
		private var scrollList: ScrollBar;
		private var cardListContainer: Container;
		private var selectRace: Select;
		private var selectLevel: Select;
		
		public function CardListComponent(_skin: DisplayObjectContainer = null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CardListComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			lblRace = getUI(Label, "lblRace") as Label;
			lblLevel = getUI(Label, "lblLevel") as Label;
			btnViewSelect = getUI(Button, "btnViewSelect") as Button;
			
			cardListContainer = new Container();
			cardListContainer.x = 49;
			cardListContainer.y = 188;
			cardListContainer.contentWidth = 387;
			cardListContainer.contentHeight = 360;
			cardListContainer.layout = new HorizontalTileLayout(cardListContainer);
			addChild(cardListContainer);
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = cardListContainer;
			
			sortChildIndex();
			addChild(scrollList);
			
			selectLevel = new Select();
			selectLevel.x = 108
			selectLevel.y = 119;
			addChild(selectLevel);
			
			selectRace = new Select();
			selectRace.x = 108
			selectRace.y = 67;
			addChild(selectRace);
		}
	}
}