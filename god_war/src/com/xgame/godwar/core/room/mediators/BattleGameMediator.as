package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	import com.xgame.godwar.core.room.views.BattleGameOtherRoleComponent;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.utils.StringUtils;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleGameMediator extends BaseMediator
	{
		public static const NAME: String = "BattleGameMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const SHOW_ROOM_DATA_NOTE: String = NAME + ".ShowRoomDataNote";
		public static const ADD_PLAYER_NOTE: String = NAME + ".AddPlayerNote";
		public static const ADD_CARD_ANIMATE_NOTE: String = NAME + ".AddCardAnimateNote";
		public static const START_CARD_ANIMATE_NOTE: String = NAME + ".StartCardAnimateNote";
		public static const DEPLOY_COMPLETE_NOTE: String = NAME + ".DeployCompleteNote";
		
		public function BattleGameMediator()
		{
			super(NAME, new BattleGameComponent());
			
			component.mediator = this;
			
			component.addEventListener(BattleGameEvent.CHOUPAI_COMPLETE_EVENT, onChouPaiComplete);
			component.addEventListener(BattleGameEvent.DEPLOY_PHASE_EVENT, onDeployPhase);
			component.addEventListener(BattleGameEvent.FIGHT_EVENT, onFight);
		}
		
		public function get component(): BattleGameComponent
		{
			return viewComponent as BattleGameComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE,
				ADD_CARD_ANIMATE_NOTE, START_CARD_ANIMATE_NOTE, DEPLOY_COMPLETE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					requestEnterRoom();
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
					showRoomData(notification.getBody() as Receive_BattleRoom_InitRoomDataLogicServer);
					break;
				case ADD_PLAYER_NOTE:
					addPlayer(notification.getBody() as Receive_BattleRoom_PlayerEnterRoomLogicServer);
					break;
				case ADD_CARD_ANIMATE_NOTE:
					component.choupaiComponent.addCardAnimate(notification.getBody() as Card);
					break;
				case START_CARD_ANIMATE_NOTE:
					component.choupaiComponent.startCardAnimate();
					break;
				case DEPLOY_COMPLETE_NOTE:
					deployComplete(String(notification.getBody()));
					break;
			}
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, { alpha: 0, ease: Strong.easeIn, onComplete: callback });
		}
		
		private function requestEnterRoom(): void
		{
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			proxy.requestEnterRoom();
		}
		
		private function showRoomData(protocol: Receive_BattleRoom_InitRoomDataLogicServer): void
		{
			component.peopleCount = protocol.peopleCount;
			component.playerGroup = protocol.playerGroup;
			component.initBattleArea();
			
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			var parameter: PlayerParameter;
			var roleComponent: BattleGameOtherRoleComponent;
			var player: Player;
			var heroParameter: HeroCardParameter;
			
			if(!StringUtils.empty(protocol.heroCardId))
			{
				heroParameter = HeroCardParameterPool.instance.get(protocol.heroCardId) as HeroCardParameter;
				component.panelComponent.mainRoleComponent.setMainRoleAvatar(heroParameter.avatarPathBig);
			}
			
			for(var i: int = 0; i<protocol.playerList.length; i++)
			{
				parameter = protocol.playerList[i];
				
				player = new Player();
				player.guid = parameter.guid;
				player.accountId = parameter.accountId;
				player.name = parameter.name;
				player.level = parameter.level;
				player.avatarId = parameter.avatarId;
				player.heroCardId = parameter.heroCardId;
				player.cash = parameter.cash;
				player.winningCount = parameter.winningCount;
				player.battleCount = parameter.battleCount;
				player.honor = parameter.honor;
				player.group = parameter.group;
				
				if(!StringUtils.empty(parameter.heroCardId))
				{
					heroParameter = HeroCardParameterPool.instance.get(parameter.heroCardId) as HeroCardParameter;
					player.heroCardPath = heroParameter.avatarPathBig;
				}
				
				roleComponent = new BattleGameOtherRoleComponent();
				roleComponent.player = player;
				
				component.addPlayer(roleComponent);
			}
		}
		
		private function addPlayer(protocol: Receive_BattleRoom_PlayerEnterRoomLogicServer): void
		{
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			
			var player: Player = new Player();
			player.guid = protocol.guid;
			player.accountId = protocol.accountId;
			player.name = protocol.name;
			player.level = protocol.level;
			player.heroCardId = protocol.heroCardId;
			player.group = protocol.group;
			
			if(!StringUtils.empty(protocol.heroCardId))
			{
				var heroParameter: HeroCardParameter = HeroCardParameterPool.instance.get(protocol.heroCardId) as HeroCardParameter;
				player.heroCardPath = heroParameter.avatarPathBig;
			}
			
			var roleComponent: BattleGameOtherRoleComponent = new BattleGameOtherRoleComponent();
			roleComponent.player = player;
			
			component.addPlayer(roleComponent);
		}
		
		private function onChouPaiComplete(evt: BattleGameEvent): void
		{
			facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择一张英灵牌放置在守护灵位置");
			facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
		}
		
		private function onDeployPhase(evt: BattleGameEvent): void
		{
			var phase: int = int(evt.value);
			
			if(phase == 2)
			{
//				facade.sendNotification(BattleGuideMediator.HIDE_NOTE, function(): void
//				{
					facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择一张英灵牌放置在进攻灵#1位置");
					facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
//				});
			}
			else if(phase == 3)
			{
//				facade.sendNotification(BattleGuideMediator.HIDE_NOTE, function(): void
//				{
					facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择一张英灵牌放置在进攻灵#2位置");
					facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
//				});
			}
			else if(phase == 4)
			{
//				facade.sendNotification(BattleGuideMediator.HIDE_NOTE, function(): void
//				{
					facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择一张英灵牌放置在进攻灵#3位置");
					facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
//				});
			}
			else if(phase == 5)
			{
//				facade.sendNotification(BattleGuideMediator.HIDE_NOTE, function(): void
//				{
					facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "部署完毕，点击“开始战斗”按钮！");
					facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
					component.panelComponent.btnFightEnabled(true);
//				});
			}
		}
		
		private function onFight(evt: BattleGameEvent): void
		{
			facade.sendNotification(BattleGuideMediator.HIDE_NOTE);
			component.panelComponent.btnFightEnabled(false);
			
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			proxy.deployComplete(component.cardDefenser, component.cardAttacker1, component.cardAttacker2, component.cardAttacker3);
		}
		
		private function deployComplete(guid: String): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == guid)
					{
						
					}
					else
					{
						component.setOtherRoleDeployComplete(guid);
					}
				}
			}
		}
	}
}