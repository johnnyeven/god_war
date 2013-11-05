package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Hall_RequestRoom extends SendingBase
	{
		public var roomType: int = int.MIN_VALUE;
		public var peopleLimit: int = int.MIN_VALUE;
		public var title: String = null;
		
		public function Send_Hall_RequestRoom()
		{
			super(SocketContextConfig.HALL_REQUEST_ROOM);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(roomType);
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(peopleLimit);
			
			_byteData.writeInt(title.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(title);
		}
	}
}