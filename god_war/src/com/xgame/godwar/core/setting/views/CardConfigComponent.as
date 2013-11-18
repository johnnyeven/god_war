package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class CardConfigComponent extends Component
	{
		private var btnSave: Button;
		private var btnBack: Button;
		private var groupList: CardGroupListComponent;
		private var cardList: CardListComponent;
		private var cardCurrentList: CardCurrentComponent;
		
		public function CardConfigComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.config.CardConfigComponent", null, false) as DisplayObjectContainer);
			
			btnSave = getUI(Button, "btnSave") as Button;
			btnBack = getUI(Button, "btnBack") as Button;
			groupList = getUI(CardGroupListComponent, "groupList") as CardGroupListComponent;
			cardList = getUI(CardListComponent, "mainList") as CardListComponent;
			cardCurrentList = getUI(CardCurrentComponent, "subList") as CardCurrentComponent;
			
			sortChildIndex();
		}
		
		public function show(): void
		{
			
		}
	}
}