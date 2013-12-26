package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.FlowLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleGamePanalComponent extends Component
	{
		private var cardContainer: Container;
		private var cardScroll: ScrollBar;
		private var btnFight: Button;
		private var btnPass: Button;
		private var _mainRoleComponent: BattleGameMainRoleComponent;
		
		public function BattleGamePanalComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGamePanalComponent", null, false) as DisplayObjectContainer);
			
			cardContainer = getUI(Container, "cardContainer") as Container;
			cardScroll = getUI(ScrollBar, "cardScroll") as ScrollBar;
			btnFight = getUI(Button, "btnFight") as Button;
			btnPass = getUI(Button, "btnPass") as Button;
			_mainRoleComponent = getUI(BattleGameMainRoleComponent, "mainRoleComponent") as BattleGameMainRoleComponent;
			
			sortChildIndex();
			
			cardContainer.layout = new FlowLayout(cardContainer);
			cardContainer.layout.hGap = -10;
			cardContainer.layout.vGap = -10;
			cardScroll.orientation = ScrollBarOrientation.HORIZONTAL;
			cardScroll.view = cardContainer;
		}
		
		public function get mainRoleComponent(): BattleGameMainRoleComponent
		{
			return _mainRoleComponent;
		}
		
		public function addCard(card: Card): void
		{
			cardContainer.add(card);
			cardContainer.layout.update();
			cardScroll.rebuild();
		}
	}
}