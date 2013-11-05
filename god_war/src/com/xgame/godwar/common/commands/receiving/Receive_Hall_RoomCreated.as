package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Hall_RoomCreated extends ReceivingBase
	{
		public var parameter: RoomListItemParameter = new RoomListItemParameter();
		
		public function Receive_Hall_RoomCreated()
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
							if (parameter.id == int.MIN_VALUE)
							{
								parameter.id = bytes.readInt();
							}
							else if(parameter.peopleCount == int.MIN_VALUE)
							{
								parameter.peopleCount = bytes.readInt();
							}
							else if(parameter.peopleLimit == int.MIN_VALUE)
							{
								parameter.peopleLimit = bytes.readInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if(StringUtils.empty(parameter.title))
							{
								parameter.title = bytes.readUTFBytes(length);
								break;
							}
							else if(StringUtils.empty(parameter.ownerName))
							{
								parameter.ownerName = bytes.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}