package com.xgame.godwar.core.room.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestEnterRoomLogicServer;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.room.mediators.BattleGameMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BattleGameProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "BattleGameProxy";
		public var currentRoomId: int;
		
		public function BattleGameProxy()
		{
			super(NAME, null);
			//进入房间失败（满员）
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER, Receive_Hall_RequestEnterRoomLogicServer);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER, onRequestEnterRoomFailed);
			//进入新房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_INIT_ROOM_LOGICSERVER, Receive_BattleRoom_InitRoomDataLogicServer);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_INIT_ROOM_LOGICSERVER, onRequestEnterRoom);
			//玩家进入房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM_LOGICSERVER, Receive_BattleRoom_PlayerEnterRoomLogicServer);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM_LOGICSERVER, onPlayerEnterRoom);
		}
		
		public function requestEnterRoom(): void
		{
			if(CommandCenter.instance.connected)
			{
				if(currentRoomId > 0)
				{
					var protocol: Send_Hall_RequestEnterRoomLogicServer = new Send_Hall_RequestEnterRoomLogicServer();
					protocol.roomId = currentRoomId;
					protocol.roomType = 0;
					
					CommandCenter.instance.send(protocol);
					facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				}
			}
		}
		
		private function onRequestEnterRoomFailed(protocol: Receive_Hall_RequestEnterRoomLogicServer): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
		}
		
		private function onRequestEnterRoom(protocol: Receive_BattleRoom_InitRoomDataLogicServer): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			setData(protocol);
			facade.sendNotification(BattleGameMediator.SHOW_ROOM_DATA_NOTE, protocol);
		}
		
		private function onPlayerEnterRoom(protocol: Receive_BattleRoom_PlayerEnterRoomLogicServer): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			facade.sendNotification(BattleGameMediator.ADD_PLAYER_NOTE, protocol);
		}
	}
}