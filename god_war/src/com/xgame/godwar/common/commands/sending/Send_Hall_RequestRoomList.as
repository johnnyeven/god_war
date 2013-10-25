package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Hall_RequestRoomList extends SendingBase
	{
		public var roomType: int = int.MIN_VALUE;
		
		public function Send_Hall_RequestRoomList()
		{
			super(SocketContextConfig.HALL_SHOW_ROOM_LIST);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(roomType);
		}
	}
}