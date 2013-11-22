package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.setting.proxy.CardGroupProxy;
	import com.xgame.godwar.core.setting.views.CardConfigComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CardConfigEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class CardConfigMediator extends BaseMediator
	{
		public static const NAME: String = "CardConfigMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const SHOW_CARD_GROUP_NOTE: String = NAME + ".ShowCardGroupNote";
		public static const SHOW_CARD_LIST_NOTE: String = NAME + ".ShowCardListNote";
		public static const SHOW_CARD_CURRENT_NOTE: String = NAME + ".ShowCardCurrentNote";
		
		public function CardConfigMediator()
		{
			super(NAME, new CardConfigComponent());
			component.mediator = this;
			_isPopUp = true;
			mode = true;
			popUpEffect = PopupEffect.NONE;
			
			component.addEventListener(CardConfigEvent.BACK_CLICK, onBtnBackClick);
			
			if(!facade.hasProxy(CardGroupProxy.NAME))
			{
				facade.registerProxy(new CardGroupProxy());
			}
		}
		
		public function get component(): CardConfigComponent
		{
			return viewComponent as CardConfigComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_CARD_GROUP_NOTE,
				SHOW_CARD_LIST_NOTE, SHOW_CARD_CURRENT_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					component.show(requestCard);
					break;
				case HIDE_NOTE:
					dispose();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
				case SHOW_CARD_GROUP_NOTE:
					addCardGroup(notification.getBody() as Vector.<CardGroupParameter>);
				case SHOW_CARD_LIST_NOTE:
					addCardList();
					break;
			}
		}
		
		private function onBtnBackClick(evt: CardConfigEvent): void
		{
			component.hide(function(): void
			{
				dispose();
			});
		}
		
		private function requestCard(): void
		{
			var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
			proxy.requestCardGroup();
		}
		
		private function addCardGroup(list: Vector.<CardGroupParameter>): void
		{
			var parameter: CardGroupParameter;
			for(var i: int = 0; i < list.length; i++)
			{
				parameter = list[i];
				component.groupList.addGroup(parameter);
			}
		}
		
		private function addCardList(): void
		{
			var card: SoulCard = new SoulCard("HuWei");
			component.cardList.addChild(card);
		}
	}
}