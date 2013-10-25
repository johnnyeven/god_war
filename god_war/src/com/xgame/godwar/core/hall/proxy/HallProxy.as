package com.xgame.godwar.core.hall.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestRoomList;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestRoomList;
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.hall.mediators.BattleHallMediator;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class HallProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "HallProxy";
		
		private var _mode: int;
		private var _roomList: Vector.<RoomListItemParameter>;
		
		public function HallProxy()
		{
			super(NAME, null);
		}

		public function get mode():int
		{
			return _mode;
		}

		public function set mode(value:int):void
		{
			_mode = value;
		}
		
		public function requestRoomList(): void
		{
			var protocol: Send_Hall_RequestRoomList = new Send_Hall_RequestRoomList();
			protocol.roomType = _mode;

			CommandList.instance.bind(SocketContextConfig.HALL_SHOW_ROOM_LIST, Receive_Hall_RequestRoomList);
			CommandCenter.instance.add(SocketContextConfig.HALL_SHOW_ROOM_LIST, onRequestRoomList);
			
			sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
			CommandCenter.instance.send(protocol);
		}
		
		private function onRequestRoomList(protocol: Receive_Hall_RequestRoomList): void
		{
			_roomList = protocol.list;
			
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			if(_mode == 0)
			{
				sendNotification(BattleHallMediator.SHOW_ROOM_LIST_NOTE, _roomList);
			}
		}

	}
}