package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Hall_RequestRoomList extends ReceivingBase
	{
		public var list: Vector.<RoomListItemParameter>;
		
		public function Receive_Hall_RequestRoomList()
		{
			super(SocketContextConfig.HALL_SHOW_ROOM_LIST);
			list = new Vector.<RoomListItemParameter>();
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				var parameter: RoomListItemParameter = new RoomListItemParameter();
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if (parameter.id == int.MIN_VALUE)
							{
								parameter.id = data.readInt();
							}
							else if(parameter.peopleCount == int.MIN_VALUE)
							{
								parameter.peopleCount = data.readInt();
							}
							else if(parameter.peopleLimit == int.MIN_VALUE)
							{
								parameter.peopleLimit = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if (StringUtils.empty(parameter.title))
							{
								parameter.title = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.ownerName))
							{
								parameter.ownerName = data.readUTFBytes(length);
							}
							break;
					}
					
					if(parameter.id != int.MIN_VALUE &&
					parameter.peopleCount != int.MIN_VALUE &&
					parameter.peopleLimit != int.MIN_VALUE &&
					!StringUtils.empty(parameter.title) &&
					!StringUtils.empty(parameter.ownerName))
					{
						list.push(parameter);
						parameter = new RoomListItemParameter();
					}
				}
			}
		}
	}
}