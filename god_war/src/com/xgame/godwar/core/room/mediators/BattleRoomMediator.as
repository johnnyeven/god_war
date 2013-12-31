package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomData;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoom;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerReady;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerSelectHero;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.AvatarParameter;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.general.proxy.CardProxy;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.room.proxy.BattleRoomProxy;
	import com.xgame.godwar.core.room.views.BattleRoomComponent;
	import com.xgame.godwar.core.room.views.BattleRoomHeroComponent;
	import com.xgame.godwar.core.setting.controllers.ShowCardConfigMediatorCommand;
	import com.xgame.godwar.events.BattleRoomEvent;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleRoomMediator extends BaseMediator
	{
		public static const NAME: String = "BattleRoomMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const SHOW_ROOM_DATA_NOTE: String = NAME + ".ShowRoomDataNote";
		public static const ADD_PLAYER_NOTE: String = NAME + ".AddPlayerNote";
		public static const REMOVE_PLAYER_NOTE: String = NAME + ".RemovePlayerNote";
		public static const PLAYER_READY_NOTE: String = NAME + ".PlayerReadyNote";
		public static const PLAYER_SELECT_HERO_NOTE: String = NAME + ".PlayerSelectHeroNote";
		
		public var currentHeroId: String;
		public var currentGroup: int;
		public var isOwner: Boolean = false;
		public var isReady: Boolean = false;
		
		public function BattleRoomMediator()
		{
			super(NAME, new BattleRoomComponent());
			component.mediator = this;
			
			component.addEventListener(BattleRoomEvent.CARD_CONFIG_CLICK, onCardConfigClick);
			component.addEventListener(BattleRoomEvent.READY_CLICK, onReadyClick);
		}
		
		public function get component(): BattleRoomComponent
		{
			return viewComponent as BattleRoomComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE,
				REMOVE_PLAYER_NOTE, PLAYER_READY_NOTE, PLAYER_SELECT_HERO_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					component.show(requestEnterRoom);
					break;
				case HIDE_NOTE:
					hide(function(): void
					{
						remove();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
				case DISPOSE_NOTE:
					hide(function(): void
					{
						dispose();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
				case SHOW_ROOM_DATA_NOTE:
					showRoomData(notification.getBody() as Receive_BattleRoom_InitRoomData);
					break;
				case ADD_PLAYER_NOTE:
					addPlayer(notification.getBody() as Receive_BattleRoom_PlayerEnterRoom);
					break;
				case REMOVE_PLAYER_NOTE:
					removePlayer(String(notification.getBody()));
					break;
				case PLAYER_READY_NOTE:
					playerReady(notification.getBody() as Receive_BattleRoom_PlayerReady);
					break;
				case PLAYER_SELECT_HERO_NOTE:
					playerSelectHero(notification.getBody() as Receive_BattleRoom_PlayerSelectHero);
					break;
			}
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, { y: -600, ease: Strong.easeIn, onComplete: callback });
		}
		
		private function onCardConfigClick(evt: BattleRoomEvent): void
		{
			facade.sendNotification(ShowCardConfigMediatorCommand.SHOW_NOTE, ShowCardConfigMediatorCommand);
		}
		
		private function onReadyClick(evt: BattleRoomEvent): void
		{
			var proxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
//			if(isOwner)
//			{
//				isReady = Boolean(evt.value);
//				proxy.startBattle();
//			}
//			else
//			{
				var ready: Boolean = Boolean(evt.value);
				proxy.updatePlayerReady(ready);
				
//				var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
//				var heroComponentList: Vector.<BattleRoomHeroComponent> = component.heroComponentList;
//				var i: int;
//				if(ready)
//				{
//					for(i = 0; i<heroComponentList.length; i++)
//					{
//						heroComponentList[i].enabled = false;
//					}
//				}
//				else
//				{
//					var soulCardIndex: Dictionary = cardProxy.soulCardIndex;
//					var heroComponent: BattleRoomHeroComponent;
//					for(i = 0; i<heroComponentList.length; i++)
//					{
//						heroComponent = heroComponentList[i];
//						if(soulCardIndex.hasOwnProperty(heroComponent.heroCardParameter.id))
//						{
//							heroComponent.enabled = true;
//						}
//					}
//				}
//			}
		}
		
		private function requestEnterRoom(): void
		{
			var proxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
			proxy.requestEnterRoom();
		}
		
		private function showRoomData(protocol: Receive_BattleRoom_InitRoomData): void
		{
			var player: Player;
			var parameter: PlayerParameter;
			
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			var container: Vector.<AvatarParameter>;
			var avatarIndex: Dictionary;
			if(proxy != null)
			{
				container = proxy.getData() as Vector.<AvatarParameter>;
				avatarIndex = proxy.avatarIndex;
			}
			
			var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
			var soulCardIndex: Dictionary = cardProxy.soulCardIndex;
			var heroList: Array = HeroCardParameterPool.instance.list;
			var heroParameter: HeroCardParameter;
			var heroComponent: BattleRoomHeroComponent;
			for(var i: int = 0; i<heroList.length; i++)
			{
				heroParameter = heroList[i] as HeroCardParameter;
				if(heroParameter != null)
				{
					heroComponent = new BattleRoomHeroComponent();
					
					if(!soulCardIndex.hasOwnProperty(heroParameter.id))
					{
						heroComponent.enabled = false;
					}
					heroComponent.heroCardParameter = heroParameter;
					component.addHero(heroComponent);
					
					heroComponent.addEventListener(MouseEvent.CLICK, onHeroClick);
				}
			}
			
			currentGroup = protocol.playerGroup;
			component.currentGroup = protocol.playerGroup;
			
			var avatarParameter: AvatarParameter;
			for(i = 0; i<protocol.playerList.length; i++)
			{
				parameter = protocol.playerList[i];
				player = new Player();
				player.guid = parameter.guid;
				player.accountId = parameter.accountId;
				player.name = parameter.name;
				player.level = parameter.level;
				player.avatarId = parameter.avatarId;
				player.cash = parameter.cash;
				player.winningCount = parameter.winningCount;
				player.battleCount = parameter.battleCount;
				player.honor = parameter.honor;
				player.group = parameter.group;
				player.heroCardId = parameter.heroCardId;
				player.ready = parameter.playerStatus == 1 ? true : false;
				
				if(protocol.playerGroup == player.group)
				{
					if(!StringUtils.empty(parameter.heroCardId))
					{
						heroParameter = HeroCardParameterPool.instance.get(parameter.heroCardId) as HeroCardParameter;
						player.heroCardPath = proxy.avatarBasePath + heroParameter.resourceId + ".png";
						
						if(component.heroComponentIndex.hasOwnProperty(parameter.heroCardId))
						{
							heroComponent = component.heroComponentIndex[parameter.heroCardId];
							heroComponent.enabled = false;
						}
					}
				}
				
				if(container != null && avatarIndex != null)
				{
					avatarParameter = container[avatarIndex[parameter.avatarId]];
					player.avatarBigPath = proxy.avatarBasePath + avatarParameter.bigPath;
					player.avatarNormalPath = proxy.avatarBasePath + avatarParameter.normalPath;
				}
				if(player.guid == protocol.ownerGuid)
				{
					player.isOwner = true;
				}
				
				component.addPlayer(player);
			}
			
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == protocol.ownerGuid)
					{
						isOwner = true;
						component.isOwner = true;
//						component.btnReady.caption = "开始游戏";
					}
				}
			}
		}
		
		private function playerReady(protocol: Receive_BattleRoom_PlayerReady): void
		{
			var ready: Boolean = Boolean(protocol.ready);
			component.setPlayerReady(protocol.guid, ready);
			
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == protocol.guid)
					{
						isReady = ready;
						component.switchReady(ready);
						
						var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
						var heroComponentList: Vector.<BattleRoomHeroComponent> = component.heroComponentList;
						var i: int;
						if(ready)
						{
							for(i = 0; i<heroComponentList.length; i++)
							{
								heroComponentList[i].enabled = false;
							}
						}
						else
						{
							var soulCardIndex: Dictionary = cardProxy.soulCardIndex;
							var heroComponent: BattleRoomHeroComponent;
							for(i = 0; i<heroComponentList.length; i++)
							{
								heroComponent = heroComponentList[i];
								if(soulCardIndex.hasOwnProperty(heroComponent.heroCardParameter.id))
								{
									heroComponent.enabled = true;
								}
							}
						}
					}
				}
			}
		}
		
		private function playerSelectHero(proto: Receive_BattleRoom_PlayerSelectHero): void
		{
			var avatar: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			var heroCardParameter: HeroCardParameter = HeroCardParameterPool.instance.get(proto.cardId) as HeroCardParameter;
			if(heroCardParameter != null)
			{
				component.setPlayerHero(proto.guid, avatar.avatarBasePath + heroCardParameter.resourceId + ".png");
			}
			
			var hero: BattleRoomHeroComponent;
			var protocolRole: Receive_Info_AccountRole = (facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy).getData() as Receive_Info_AccountRole;
			if(protocolRole != null && protocolRole.guid != proto.guid)
			{
				var lastFlag: Boolean = false;
				var currentFlag: Boolean = false;
				for(var j: int = 0; j<component.heroComponentList.length; j++)
				{
					
					hero = component.heroComponentList[j];
					if(proto.lastCardId == "")
					{
						if(hero.heroCardParameter.id == proto.cardId)
						{
							hero.enabled = false;
							break;
						}
					}
					else
					{
						if(lastFlag && currentFlag)
						{
							break;
						}
						
						if(hero.heroCardParameter.id == proto.lastCardId)
						{
							hero.enabled = true;
							lastFlag = true;
							continue;
						}
						else if(hero.heroCardParameter.id == proto.cardId)
						{
							hero.enabled = false;
							currentFlag = true;
							continue;
						}
					}
				}
			}
		}
		
		private function addPlayer(protocol: Receive_BattleRoom_PlayerEnterRoom): void
		{
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			var container: Vector.<AvatarParameter>;
			var avatarIndex: Dictionary;
			if(proxy != null)
			{
				container = proxy.getData() as Vector.<AvatarParameter>;
				avatarIndex = proxy.avatarIndex;
			}
			
			var player: Player = new Player();
			player.guid = protocol.guid;
			player.accountId = protocol.accountId;
			player.name = protocol.name;
			player.level = protocol.level;
			player.avatarId = protocol.avatarId;
			player.cash = protocol.cash;
			player.winningCount = protocol.winningCount;
			player.battleCount = protocol.battleCount;
			player.honor = protocol.honor;
			player.group = protocol.group;
			
			if(container != null && avatarIndex != null)
			{
				var avatarParameter: AvatarParameter = container[avatarIndex[protocol.avatarId]];
				player.avatarBigPath = proxy.avatarBasePath + avatarParameter.bigPath;
				player.avatarNormalPath = proxy.avatarBasePath + avatarParameter.normalPath;
			}
			
			component.addPlayer(player);
		}
		
		private function removePlayer(guid: String): void
		{
			component.removePlayer(guid);
		}
		
		private function onHeroClick(evt: MouseEvent): void
		{
			var heroComponent: BattleRoomHeroComponent = evt.currentTarget as BattleRoomHeroComponent;
			if(heroComponent.enabled)
			{
				var list: Vector.<BattleRoomHeroComponent> = component.heroComponentList;
				for(var i: int = 0; i<list.length; i++)
				{
					list[i].selected = false;
				}
				heroComponent.selected = true;
				currentHeroId = heroComponent.heroCardParameter.id;
				
				var proxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
				proxy.selectHero(currentHeroId);
			}
		}
	}
}