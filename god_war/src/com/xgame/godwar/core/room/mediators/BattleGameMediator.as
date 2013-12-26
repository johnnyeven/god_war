package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	import com.xgame.godwar.core.room.views.BattleGameOtherRoleComponent;
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
		
		public function BattleGameMediator()
		{
			super(NAME, new BattleGameComponent());
			
			component.mediator = this;
		}
		
		public function get component(): BattleGameComponent
		{
			return viewComponent as BattleGameComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE,
				ADD_CARD_ANIMATE_NOTE, START_CARD_ANIMATE_NOTE];
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
	}
}