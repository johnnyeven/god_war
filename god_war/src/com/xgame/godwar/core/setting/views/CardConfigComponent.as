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
		private var _groupList: CardGroupListComponent;
		private var _cardList: CardListComponent;
		private var _cardCurrentList: CardCurrentComponent;
		
		public function CardConfigComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.config.CardConfigComponent", null, false) as DisplayObjectContainer);
			
			btnSave = getUI(Button, "btnSave") as Button;
			btnBack = getUI(Button, "btnBack") as Button;
			_groupList = getUI(CardGroupListComponent, "groupList") as CardGroupListComponent;
			_cardList = getUI(CardListComponent, "mainList") as CardListComponent;
			_cardCurrentList = getUI(CardCurrentComponent, "subList") as CardCurrentComponent;
			
			sortChildIndex();
			
			btnSave.x = -btnSave.width;
			btnBack.x = -btnBack.width;
			_groupList.y = -_groupList.height;
			_cardList.x = GameManager.container.stageWidth;
			_cardCurrentList.x = GameManager.container.stageWidth;
			
			btnSave.addEventListener(MouseEvent.CLICK, onBtnSaveClick);
			btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
		}
		
		public function show(callback: Function = null): void
		{
			TweenLite.to(_groupList, .5, {y: 0, ease: Strong.easeOut});
			TweenLite.to(btnSave, .5, {x: 12, ease: Strong.easeOut, delay: .3});
			TweenLite.to(btnBack, .5, {x: 12, ease: Strong.easeOut, delay: .6});
			TweenLite.to(_cardList, .5, {x: 554, ease: Strong.easeOut, delay: .9});
			TweenLite.to(_cardCurrentList, .5, {x: 554, ease: Strong.easeOut, delay: .9});
			TweenLite.to(_cardCurrentList, .5, {x: 190, ease: Strong.easeOut, delay: 1.2, onComplete: callback});
		}
		
		public function hide(callback: Function = null): void
		{
			_cardCurrentList.emptyCards();
			_groupList.removeAll();
			
			TweenLite.to(_cardCurrentList, .5, {x: 554, ease: Strong.easeIn});
			TweenLite.to(_cardCurrentList, .5, {x: GameManager.container.stageWidth, ease: Strong.easeIn, delay: .3});
			TweenLite.to(_cardList, .5, {x: GameManager.container.stageWidth, ease: Strong.easeIn, delay: .3});
			TweenLite.to(btnBack, .5, {x: -btnBack.width, ease: Strong.easeIn, delay: .6});
			TweenLite.to(btnSave, .5, {x: -btnSave.width, ease: Strong.easeIn, delay: .9});
			TweenLite.to(_groupList, .5, {y: -_groupList.height, ease: Strong.easeIn, delay: 1.2, onComplete: callback});
		}
		
		private function onBtnSaveClick(evt: MouseEvent): void
		{
			dispatchEvent(new CardConfigEvent(CardConfigEvent.SAVE_CLICK));
		}
		
		private function onBtnBackClick(evt: MouseEvent): void
		{
			dispatchEvent(new CardConfigEvent(CardConfigEvent.BACK_CLICK));
		}

		public function get groupList():CardGroupListComponent
		{
			return _groupList;
		}

		public function get cardList():CardListComponent
		{
			return _cardList;
		}

		public function get cardCurrentList():CardCurrentComponent
		{
			return _cardCurrentList;
		}

	}
}