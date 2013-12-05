package com.xgame.godwar.core.room.mediators
{
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomData;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoom;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.AvatarParameter;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.room.proxy.BattleRoomProxy;
	import com.xgame.godwar.core.room.views.BattleRoomComponent;
	import com.xgame.godwar.core.setting.controllers.ShowCardConfigMediatorCommand;
	import com.xgame.godwar.events.BattleRoomEvent;
	
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
		
		public function BattleRoomMediator()
		{
			super(NAME, new BattleRoomComponent());
			
			component.addEventListener(BattleRoomEvent.CARD_CONFIG_CLICK, onCardConfigClick);
			component.addEventListener(BattleRoomEvent.READY_CLICK, onReadyClick);
		}
		
		public function get component(): BattleRoomComponent
		{
			return viewComponent as BattleRoomComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE];
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
					remove();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
				case SHOW_ROOM_DATA_NOTE:
					showRoomData(notification.getBody() as Receive_BattleRoom_InitRoomData);
					break;
				case ADD_PLAYER_NOTE:
					addPlayer(notification.getBody() as Receive_BattleRoom_PlayerEnterRoom);
					break;
			}
		}
		
		private function onCardConfigClick(evt: BattleRoomEvent): void
		{
			facade.sendNotification(ShowCardConfigMediatorCommand.SHOW_NOTE, ShowCardConfigMediatorCommand);
		}
		
		private function onReadyClick(evt: BattleRoomEvent): void
		{
			
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
			
			var avatarParameter: AvatarParameter;
			for(var i: int = 0; i<protocol.playerList.length; i++)
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
						component.btnReady.caption = "开始游戏";
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
	}
}