package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	
	import flash.utils.ByteArray;

	public class Receive_Hall_RequestEnterRoomLogicServer extends ReceivingBase
	{
		public var flag: int = int.MIN_VALUE;
		
		public function Receive_Hall_RequestEnterRoomLogicServer()
		{
			super(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER);
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if (flag == int.MIN_VALUE)
							{
								flag = data.readInt();
							}
							break;
					}
				}
			}
		}
	}
}