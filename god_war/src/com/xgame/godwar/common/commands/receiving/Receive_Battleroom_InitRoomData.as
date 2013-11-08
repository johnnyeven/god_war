package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Battleroom_InitRoomData extends ReceivingBase
	{
		public var roomId: int = int.MIN_VALUE;
		public var roomTitle: String;
		public var ownerGuid: String;
		public var ownerName: String;
		public var peopleCount: int = int.MIN_VALUE;
		public var peopleLimit: int = int.MIN_VALUE;
		public var playerList: Vector.<PlayerParameter> = new Vector.<PlayerParameter>();
		
		public function Receive_Battleroom_InitRoomData()
		{
			super(SocketContextConfig.BATTLEROOM_INIT_ROOM);
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				var parameter: PlayerParameter = new PlayerParameter();
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if(roomId == int.MIN_VALUE)
							{
								roomId = data.readInt();
							}
							else if (peopleCount == int.MIN_VALUE)
							{
								peopleCount = data.readInt();
							}
							else if(peopleLimit == int.MIN_VALUE)
							{
								peopleLimit = data.readInt();
							}
							else if(parameter.playerStatus == int.MIN_VALUE)
							{
								parameter.playerStatus = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if (StringUtils.empty(roomTitle))
							{
								roomTitle = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(ownerGuid))
							{
								ownerGuid = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(ownerName))
							{
								ownerName = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.guid))
							{
								parameter.guid = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.name))
							{
								parameter.name = data.readUTFBytes(length);
							}
							break;
					}
					
					if(!StringUtils.empty(parameter.guid) &&
						!StringUtils.empty(parameter.name) &&
						parameter.playerStatus != int.MIN_VALUE)
					{
						playerList.push(parameter);
						parameter = new PlayerParameter();
					}
				}
			}
		}
	}
}