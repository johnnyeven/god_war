package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestCardGroup;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.SoulCardProxy;
	import com.xgame.godwar.core.setting.proxy.CardGroupProxy;
	import com.xgame.godwar.core.setting.views.CardConfigComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CardConfigEvent;
	import com.xgame.godwar.liteui.component.ListItem;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
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
		
		public var currentGroupId: int;
		
		public function CardConfigMediator()
		{
			super(NAME, new CardConfigComponent());
			component.mediator = this;
			_isPopUp = true;
			mode = true;
			popUpEffect = PopupEffect.NONE;
			
			component.addEventListener(CardConfigEvent.BACK_CLICK, onBtnBackClick);
			component.addEventListener(CardConfigEvent.GROUP_CLICK, onGroupClick);
			
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
				remove();
			});
		}
		
		private function onGroupClick(evt: CardConfigEvent): void
		{
			var listItem: ListItem = evt.value as ListItem;
			evt.stopImmediatePropagation();
			currentGroupId = int(listItem.value);
			if(listItem != null)
			{
				var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
				var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
				var parameter: CardGroupParameter;
				for(var i: int = 0; i < protocol.list.length; i++)
				{
					parameter = protocol.list[i];
					if(listItem.value == parameter.groupId)
					{
						break;
					}
				}
				
				var soulCardProxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
				var soulCardIndex: Dictionary = soulCardProxy.soulCardIndex;
				var soulCardList: Array = soulCardProxy.getData() as Array;
				var j: String;
				for(j in soulCardList)
				{
					soulCardList[j].enabled = true;
				}
				component.cardCurrentList.emptyCards();
				if(parameter != null)
				{
					var myCard: Card;
					for(j in parameter.cardList)
					{
						component.cardCurrentList.addCard(parameter.cardList[j]);
						if(soulCardIndex.hasOwnProperty(parameter.cardList[j].id))
						{
							myCard = soulCardList[soulCardIndex[parameter.cardList[j].id]];
							myCard.enabled = false;
						}
					}
				}
			}
		}
		
		private function requestCard(): void
		{
			var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
			if(proxy.getData() != null)
			{
				var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
				addCardGroup(protocol.list);
			}
			else
			{
				proxy.requestCardGroup();
			}
			
			addCardList();
		}
		
		private function addCardGroup(list: Vector.<CardGroupParameter>): void
		{
			var parameter: CardGroupParameter;
			component.groupList.removeAll();
			for(var i: int = 0; i < list.length; i++)
			{
				parameter = list[i];
				component.groupList.addGroup(parameter);
			}
		}
		
		private function addCardList(): void
		{
			var proxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
			var list: Array = proxy.getData() as Array;
			var card: Card;
			if(list != null && list.length > 0)
			{
				for(var i: String in list)
				{
					card = list[i];
					card.addEventListener(MouseEvent.CLICK, onCardListClick);
					component.cardList.addCard(card);
				}
			}
		}
		
		private function onCardListClick(evt: MouseEvent): void
		{
			var card: Card = evt.currentTarget as Card;
			if(card.enabled)
			{
				card.enabled = false;
				var clone: Card = card.clone();
				component.cardCurrentList.addCard(clone);
				
				var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
				var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
				var parameter: CardGroupParameter;
				for(var i: int = 0; i < protocol.list.length; i++)
				{
					parameter = protocol.list[i];
					if(currentGroupId == parameter.groupId)
					{
						break;
					}
				}
				if(parameter != null)
				{
					parameter.cardList.push(clone);
				}
			}
		}
	}
}