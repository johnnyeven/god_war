package com.xgame.godwar.core.room.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomData;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoom;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerLeaveRoom;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerReady;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerSelectHero;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestEnterRoom;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestRoom;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_PlayerReady;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_PlayerSelectHero;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_StartBattle;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestEnterRoom;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestRoom;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.hall.mediators.BattleHallMediator;
	import com.xgame.godwar.core.hall.mediators.CreateBattleRoomMediator;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.room.controllers.ShowBattleRoomMediatorCommand;
	import com.xgame.godwar.core.room.mediators.BattleRoomMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BattleRoomProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "BattleRoomProxy";
		public var currentRoomId: int;
		
		public function BattleRoomProxy()
		{
			super(NAME, null);
			//请求新房间
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ROOM, Receive_Hall_RequestRoom);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ROOM, onRoomCreated);
			//进入房间失败（满员）
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ENTER_ROOM, Receive_Hall_RequestEnterRoom);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ENTER_ROOM, onRequestEnterRoomFailed);
			//进入新房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_INIT_ROOM, Receive_BattleRoom_InitRoomData);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_INIT_ROOM, onRequestEnterRoom);
			//玩家进入房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM, Receive_BattleRoom_PlayerEnterRoom);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM, onPlayerEnterRoom);
			//玩家离开房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_LEAVE_ROOM, Receive_BattleRoom_PlayerLeaveRoom);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_LEAVE_ROOM, onPlayerLeaveRoom);
			//玩家装备就绪
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_READY, Receive_BattleRoom_PlayerReady);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_READY, onPlayerReady);
			//选择英雄
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_SELECTED_HERO, Receive_BattleRoom_PlayerSelectHero);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_SELECTED_HERO, onPlayerSelectHero);
		}
		
		public function requestRoom(roomType: int, title: String, peopleLimit: int): void
		{
			if(CommandCenter.instance.connected)
			{
				if(peopleLimit > 0)
				{
					var protocol: Send_Hall_RequestRoom = new Send_Hall_RequestRoom();
					protocol.roomType = roomType;
					protocol.peopleLimit = peopleLimit;
					protocol.title = title;
					
					CommandCenter.instance.send(protocol);
					facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				}
			}
		}
		
		private function onRoomCreated(protocol: Receive_Hall_RequestRoom): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			currentRoomId = protocol.roomId;
			
			var mediator: CreateBattleRoomMediator = facade.retrieveMediator(CreateBattleRoomMediator.NAME) as CreateBattleRoomMediator;
			mediator.onDestroy = function(): void
			{
				facade.sendNotification(BattleHallMediator.DISPOSE_NOTE, function(): void
				{
					facade.sendNotification(ShowBattleRoomMediatorCommand.SHOW_NOTE);
				});
			}
			mediator.dispose();
		}
		
		public function requestEnterRoom(): void
		{
			if(CommandCenter.instance.connected)
			{
				if(currentRoomId > 0)
				{
					var protocol: Send_Hall_RequestEnterRoom = new Send_Hall_RequestEnterRoom();
					protocol.roomId = currentRoomId;
					protocol.roomType = 0;
					
					CommandCenter.instance.send(protocol);
					facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				}
			}
		}
		
		private function onRequestEnterRoomFailed(protocol: Receive_Hall_RequestEnterRoom): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
		}
		
		private function onRequestEnterRoom(protocol: Receive_BattleRoom_InitRoomData): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			setData(protocol);
			facade.sendNotification(BattleRoomMediator.SHOW_ROOM_DATA_NOTE, protocol);
		}
		
		private function onPlayerEnterRoom(protocol: Receive_BattleRoom_PlayerEnterRoom): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			facade.sendNotification(BattleRoomMediator.ADD_PLAYER_NOTE, protocol);
		}
		
		private function onPlayerLeaveRoom(protocol: Receive_BattleRoom_PlayerLeaveRoom): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			facade.sendNotification(BattleRoomMediator.REMOVE_PLAYER_NOTE, protocol.guid);
		}
		
		public function updatePlayerReady(ready: Boolean): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_BattleRoom_PlayerReady = new Send_BattleRoom_PlayerReady();
				protocol.ready = ready ? 1 : 0;
				
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onPlayerReady(protocol: Receive_BattleRoom_PlayerReady): void
		{
			facade.sendNotification(BattleRoomMediator.PLAYER_READY_NOTE, protocol);
		}
		
		public function selectHero(id: String): void
		{
			if(CommandCenter.instance.connected && id != null)
			{
				var protocol: Send_BattleRoom_PlayerSelectHero = new Send_BattleRoom_PlayerSelectHero();
				protocol.cardId = id;
				
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onPlayerSelectHero(protocol: Receive_BattleRoom_PlayerSelectHero): void
		{
			facade.sendNotification(BattleRoomMediator.PLAYER_SELECT_HERO_NOTE, protocol);
		}
		
		public function startBattle(): void
		{
			if(CommandCenter.instance.connected && currentRoomId != 0)
			{
				var protocol: Send_BattleRoom_StartBattle = new Send_BattleRoom_StartBattle();
				protocol.roomId = currentRoomId;
				
				CommandCenter.instance.send(protocol);
			}
		}
	}
}