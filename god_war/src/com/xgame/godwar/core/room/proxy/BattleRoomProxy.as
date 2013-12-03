package com.xgame.godwar.core.room.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestRoom;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestRoom;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.hall.mediators.BattleHallMediator;
	import com.xgame.godwar.core.hall.mediators.CreateBattleRoomMediator;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.room.controllers.ShowBattleRoomMediatorCommand;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BattleRoomProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "BattleRoomProxy";
		public var currentRoomId: int;
		
		public function BattleRoomProxy()
		{
			super(NAME, null);
			
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ROOM, Receive_Hall_RequestRoom);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ROOM, onRoomCreated);
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
				
			}
		}
	}
}