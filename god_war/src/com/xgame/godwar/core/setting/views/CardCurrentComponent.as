package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class CardCurrentComponent extends Component
	{
		private var lblTitle: Label;
		private var btnViewSelect: Button;
		private var scrollList: ScrollBar;
		private var cardListContainer: Container;
		
		public function CardCurrentComponent(_skin: DisplayObjectContainer = null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CardCurrentComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			btnViewSelect = getUI(Button, "btnViewSelect") as Button;
			
			cardListContainer = new Container();
			cardListContainer.x = 49;
			cardListContainer.y = 98;
			cardListContainer.contentWidth = 315;
			cardListContainer.contentHeight = 446;
			cardListContainer.layout = new HorizontalTileLayout(cardListContainer);
			addChild(cardListContainer);
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = cardListContainer;
			
			sortChildIndex();
			addChild(scrollList);
		}
		
		public function addCard(c: Card): void
		{
			cardListContainer.add(c);
			cardListContainer.layout.update();
			scrollList.rebuild();
		}
		
		public function emptyCards(): void
		{
			cardListContainer.removeAll();
			cardListContainer.layout.update();
			scrollList.rebuild();
		}
	}
}