package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandby;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandbyConfirm;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.parameters.card.CardContainerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.general.proxy.CardProxy;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	import com.xgame.godwar.core.room.views.BattleGameOtherRoleComponent;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.display.renders.Render;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UIUtils;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleGameMediator extends BaseMediator
	{
		public static const NAME: String = "BattleGameMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const DEFINE_PLAYER_NOTE: String = NAME + ".DefinePlayerNote";
		public static const SHOW_ROOM_DATA_NOTE: String = NAME + ".ShowRoomDataNote";
		public static const ADD_PLAYER_NOTE: String = NAME + ".AddPlayerNote";
		public static const ADD_CARD_ANIMATE_NOTE: String = NAME + ".AddCardAnimateNote";
		public static const START_CARD_ANIMATE_NOTE: String = NAME + ".StartCardAnimateNote";
		public static const DEPLOY_COMPLETE_NOTE: String = NAME + ".DeployCompleteNote";
		public static const START_DICE_NOTE: String = NAME + ".StartDiceNote";
		public static const PHASE_ROUND_STANDBY_NOTE: String = NAME + ".PhaseRoundStandbyNote";
		public static const PHASE_ROUND_STANDBY_COMPLETE_NOTE: String = NAME + ".PhaseRoundStandbyCompleteNote";
		
		private var player: Player;
		
		public function BattleGameMediator()
		{
			super(NAME, new BattleGameComponent());
			
			component.mediator = this;
			
			component.addEventListener(BattleGameEvent.CHOUPAI_COMPLETE_EVENT, onChouPaiComplete);
			component.addEventListener(BattleGameEvent.DEPLOY_PHASE_EVENT, onDeployPhase);
			component.addEventListener(BattleGameEvent.FIGHT_EVENT, onFight);
			component.addEventListener(BattleGameEvent.ROUND_STANDBY_EVENT, onRoundStandby);
			
			EffectCenter.instance.start();
		}
		
		public function get component(): BattleGameComponent
		{
			return viewComponent as BattleGameComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, DEFINE_PLAYER_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE,
				ADD_CARD_ANIMATE_NOTE, START_CARD_ANIMATE_NOTE, DEPLOY_COMPLETE_NOTE, START_DICE_NOTE,
				PHASE_ROUND_STANDBY_NOTE, PHASE_ROUND_STANDBY_COMPLETE_NOTE];
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
				case DEFINE_PLAYER_NOTE:
					player = notification.getBody() as Player;
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
				case START_DICE_NOTE:
					startDice(notification.getBody() as Dictionary);
					break;
				case PHASE_ROUND_STANDBY_NOTE:
					phaseRoundStandby((notification.getBody() as Receive_BattleRoom_PhaseRoundStandby).guid);
					break;
				case PHASE_ROUND_STANDBY_COMPLETE_NOTE:
					phaseRoundStandbyComplete(notification.getBody() as Receive_BattleRoom_PhaseRoundStandbyConfirm);
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
			facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择出四张英灵牌放置在阵形位置");
			facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
		}
		
		private function onDeployPhase(evt: BattleGameEvent): void
		{
			var phase: int = int(evt.value);
			
			if(phase == 5)
			{
				facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "部署完毕，点击“开始战斗”按钮！");
				facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
				component.panelComponent.btnFightEnabled(true);
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
		
		private function startDice(parameter: Dictionary): void
		{
			var componentIndex: Dictionary = component.componentIndex;
			var otherRoleComponent: BattleGameOtherRoleComponent;
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					for(var guid: String in parameter)
					{
						if(protocolRole.guid == guid)
						{
							component.panelComponent.mainRoleComponent.startDice(int(parameter[guid]));
						}
						else
						{
							otherRoleComponent = componentIndex[guid];
							if(otherRoleComponent != null)
							{
								otherRoleComponent.startDice(int(parameter[guid]));
							}
						}
					}
					
					TimerManager.instance.add(5000, clearDice);
				}
			}
		}
		
		private function clearDice(): void
		{
			var otherRoleComponent: BattleGameOtherRoleComponent;
			var componentIndex: Dictionary = component.componentIndex;
			
			for each(otherRoleComponent in componentIndex)
			{
				otherRoleComponent.removeDice();
			}
			component.panelComponent.mainRoleComponent.removeDice();
			
			TimerManager.instance.remove(clearDice);
		}
		
		private function phaseRoundStandby(guid: String): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == guid)
					{
						component.paiduiComponent.visible = true;
					}
					else
					{
						var componentIndex: Dictionary = component.componentIndex;
						var otherRoleComponent: BattleGameOtherRoleComponent;
						otherRoleComponent = componentIndex[guid];
						if(otherRoleComponent != null)
						{
							
						}
					}
				}
			}
		}
		
		private function onRoundStandby(evt: BattleGameEvent): void
		{
			var tmp: Array = evt.value as Array;
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			if(tmp != null && proxy != null)
			{
				proxy.roundStandbyComplete(tmp[0], tmp[1]);
			}
		}
		
		private function phaseRoundStandbyComplete(protocol: Receive_BattleRoom_PhaseRoundStandbyConfirm): void
		{
			if(protocol != null)
			{
				var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
				if(cardProxy != null)
				{
					var parameter: CardContainerParameter = cardProxy.container;
					var cardIndex: Dictionary = cardProxy.soulCardIndex;
					var index: int;
					var card: SoulCard;
					
					for(var i: int = 0; i < protocol.soulCardList.length; i++)
					{
						if(cardIndex.hasOwnProperty(protocol.soulCardList[i]))
						{
							index = cardIndex[protocol.soulCardList[i]];
							card = parameter.soulCardList[index];
							player.removeSoulCard(card);
							player.addCardHand(card);
							component.paiduiComponent.addCard(card);
						}
					}
					component.paiduiComponent.showCards();
				}
			}
		}
	}
}