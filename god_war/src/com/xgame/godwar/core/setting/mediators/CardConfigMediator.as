package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestCardGroup;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_SaveCardConfig;
	import com.xgame.godwar.common.commands.sending.Send_Info_SaveCardConfig;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.SoulCardProxy;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.setting.proxy.CardGroupProxy;
	import com.xgame.godwar.core.setting.views.CardConfigComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CardConfigEvent;
	import com.xgame.godwar.liteui.component.ListItem;
	
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
		public static const ADD_CARD_GROUP_NOTE: String = NAME + ".AddCardGroupNote";
		public static const REMOVE_CARD_GROUP_NOTE: String = NAME + ".RemoveCardGroupNote";
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
			
			component.addEventListener(CardConfigEvent.SAVE_CLICK, onBtnSaveClick);
			component.addEventListener(CardConfigEvent.BACK_CLICK, onBtnBackClick);
			component.addEventListener(CardConfigEvent.GROUP_CLICK, onGroupClick);
			component.addEventListener(CardConfigEvent.CREATE_GROUP_CLICK, onCreateGroupClick);
			component.addEventListener(CardConfigEvent.DELETE_GROUP_CLICK, onDeleteGroupClick);
			
			if(!facade.hasMediator(CreateGroupMediator.NAME))
			{
				facade.registerMediator(new CreateGroupMediator());
			}
			if(!facade.hasMediator(DeleteGroupMediator.NAME))
			{
				facade.registerMediator(new DeleteGroupMediator());
			}
			if(!facade.hasProxy(CardGroupProxy.NAME))
			{
				facade.registerProxy(new CardGroupProxy());
			}
			
			CommandList.instance.bind(SocketContextConfig.INFO_SAVE_CARD_GROUP, Receive_Info_SaveCardConfig);
			CommandCenter.instance.add(SocketContextConfig.INFO_SAVE_CARD_GROUP, onSaveCardConfig);
		}
		
		public function get component(): CardConfigComponent
		{
			return viewComponent as CardConfigComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_CARD_GROUP_NOTE,
				ADD_CARD_GROUP_NOTE, REMOVE_CARD_GROUP_NOTE, SHOW_CARD_LIST_NOTE,
				SHOW_CARD_CURRENT_NOTE];
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
					showCardGroup(notification.getBody() as Vector.<CardGroupParameter>);
					break;
				case ADD_CARD_GROUP_NOTE:
					addCardGroup(notification.getBody() as CardGroupParameter);
					break;
				case REMOVE_CARD_GROUP_NOTE:
					removeCardGroup(int(notification.getBody()));
					break;
				case SHOW_CARD_LIST_NOTE:
					addCardList();
					break;
			}
		}
		
		private function onBtnSaveClick(evt: CardConfigEvent): void
		{
			if(CommandCenter.instance.connected && currentGroupId > 0)
			{
				var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
				var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
				
				var send: Send_Info_SaveCardConfig = new Send_Info_SaveCardConfig();
				send.currentGroupId = currentGroupId;
				send.list = protocol.list;
				
				CommandCenter.instance.send(send);
				facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
			}
		}
		
		private function onBtnBackClick(evt: CardConfigEvent): void
		{
			var soulCardProxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
			var soulCardList: Array = soulCardProxy.getData() as Array;
			for(var j: String in soulCardList)
			{
				soulCardList[j].enabled = true;
			}
			
			currentGroupId = 0;
			
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
					var card: Card;
					for(j in parameter.cardList)
					{
						card = parameter.cardList[j] as Card;
						if(!card.hasEventListener(MouseEvent.CLICK))
						{
							card.addEventListener(MouseEvent.CLICK, onCurrentCardListClick);
						}
						component.cardCurrentList.addCard(card);
						if(soulCardIndex.hasOwnProperty(card.id))
						{
							myCard = soulCardList[soulCardIndex[card.id]];
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
				showCardGroup(protocol.list);
			}
			else
			{
				proxy.requestCardGroup();
			}
			
			addCardList();
		}
		
		private function showCardGroup(list: Vector.<CardGroupParameter>): void
		{
			var parameter: CardGroupParameter;
			component.groupList.removeAll();
			for(var i: int = 0; i < list.length; i++)
			{
				parameter = list[i];
				component.groupList.addGroup(parameter);
			}
		}
		
		private function addCardGroup(parameter: CardGroupParameter): void
		{
			component.groupList.addGroup(parameter);
			
			var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
			var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
			protocol.list.push(parameter);
		}
		
		private function removeCardGroup(groupId: int): void
		{
			component.groupList.removeGroupId(groupId);
			
			component.cardCurrentList.emptyCards();
			currentGroupId = 0;
			
			var proxy: CardGroupProxy = facade.retrieveProxy(CardGroupProxy.NAME) as CardGroupProxy;
			var protocol: Receive_Hall_RequestCardGroup = proxy.getData() as Receive_Hall_RequestCardGroup;
			
			var i: int;
			for(i = 0; i<protocol.list.length; i++)
			{
				if(protocol.list[i].groupId == groupId)
				{
					protocol.list.splice(i, 1);
				}
			}
			
			var soulCardProxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
			var soulCardList: Array = soulCardProxy.getData() as Array;
			for(var j: String in soulCardList)
			{
				soulCardList[j].enabled = true;
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
					if(!card.hasEventListener(MouseEvent.CLICK))
					{
						card.addEventListener(MouseEvent.CLICK, onCardListClick);
					}
					component.cardList.addCard(card);
				}
			}
		}
		
		private function onCardListClick(evt: MouseEvent): void
		{
			var card: Card = evt.currentTarget as Card;
			if(card.enabled && currentGroupId > 0)
			{
				card.enabled = false;
				var clone: Card = card.clone();
				component.cardCurrentList.addCard(clone);
				
				clone.addEventListener(MouseEvent.CLICK, onCurrentCardListClick);
				
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
		
		private function onCurrentCardListClick(evt: MouseEvent): void
		{
			var card: Card = evt.currentTarget as Card;
			
			var soulCardProxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
			var soulCardIndex: Dictionary = soulCardProxy.soulCardIndex;
			var soulCardList: Array = soulCardProxy.getData() as Array;
			
			if(soulCardIndex.hasOwnProperty(card.id))
			{
				var myCard: Card = soulCardList[soulCardIndex[card.id]];
				myCard.enabled = true;
			}
			
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
				var index: int = parameter.cardList.indexOf(card);
				if(index >= 0)
				{
					parameter.cardList.splice(index, 1);
				}
			}
			
			component.cardCurrentList.removeCard(card);
			card.dispose();
			card = null;
		}
		
		private function onCreateGroupClick(evt: CardConfigEvent): void
		{
			evt.stopImmediatePropagation();
			
			facade.sendNotification(CreateGroupMediator.SHOW_NOTE);
		}
		
		private function onDeleteGroupClick(evt: CardConfigEvent): void
		{
			evt.stopImmediatePropagation();
			
			if(currentGroupId > 0)
			{
				facade.sendNotification(DeleteGroupMediator.SHOW_NOTE, currentGroupId);
			}
		}
		
		private function onSaveCardConfig(protocol: Receive_Info_SaveCardConfig): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
		}
	}
}