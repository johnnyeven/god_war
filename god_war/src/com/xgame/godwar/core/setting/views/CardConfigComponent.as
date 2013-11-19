package com.xgame.godwar.core.setting.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.events.CardConfigEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
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
			
			btnSave.x = -btnSave.width;
			btnBack.x = -btnBack.width;
			groupList.y = -groupList.height;
			cardList.x = GameManager.container.stageWidth;
			cardCurrentList.x = GameManager.container.stageWidth;
			
			btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
		}
		
		public function show(): void
		{
			TweenLite.to(groupList, .5, {y: 0, ease: Strong.easeOut});
			TweenLite.to(btnSave, .5, {x: 12, ease: Strong.easeOut, delay: .3});
			TweenLite.to(btnBack, .5, {x: 12, ease: Strong.easeOut, delay: .6});
			TweenLite.to(cardList, .5, {x: 554, ease: Strong.easeOut, delay: .9});
			TweenLite.to(cardCurrentList, .5, {x: 554, ease: Strong.easeOut, delay: .9});
			TweenLite.to(cardCurrentList, .5, {x: 190, ease: Strong.easeOut, delay: 1.2});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(cardCurrentList, .5, {x: 554, ease: Strong.easeIn});
			TweenLite.to(cardCurrentList, .5, {x: GameManager.container.stageWidth, ease: Strong.easeIn, delay: .3});
			TweenLite.to(cardList, .5, {x: GameManager.container.stageWidth, ease: Strong.easeIn, delay: .3});
			TweenLite.to(btnBack, .5, {x: -btnBack.width, ease: Strong.easeIn, delay: .6});
			TweenLite.to(btnSave, .5, {x: -btnSave.width, ease: Strong.easeIn, delay: .9});
			TweenLite.to(groupList, .5, {y: -groupList.height, ease: Strong.easeIn, delay: 1.2, onComplete: callback});
		}
		
		private function onBtnBackClick(evt: MouseEvent): void
		{
			dispatchEvent(new CardConfigEvent(CardConfigEvent.BACK_CLICK));
		}
	}
}