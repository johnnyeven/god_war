package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Hall_RequestEnterRoomLogicServer extends SendingBase
	{
		public var roomId: int = int.MIN_VALUE;
		public var roomType: int = int.MIN_VALUE;
		
		public function Send_Hall_RequestEnterRoomLogicServer()
		{
			super(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(roomType);
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(roomId);
		}
	}
}