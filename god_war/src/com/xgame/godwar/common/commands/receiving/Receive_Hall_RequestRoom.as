package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	
	import flash.utils.ByteArray;

	public class Receive_Hall_RequestRoom extends ReceivingBase
	{
		public var roomId: int = int.MIN_VALUE;
		
		public function Receive_Hall_RequestRoom()
		{
			super(SocketContextConfig.HALL_ROOM_CREATED);
		}
		
		override public function fill(bytes: ByteArray):void
		{
			super.fill(bytes);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				while (bytes.bytesAvailable > 8)
				{
					length = bytes.readInt();
					type = bytes.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if (roomId == int.MIN_VALUE)
							{
								roomId = bytes.readInt();
							}
							break;
					}
				}
			}
		}
	}
}