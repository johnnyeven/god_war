package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UInt64;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_InitRoomDataLogicServer extends ReceivingBase
	{
		public var roomId: int = int.MIN_VALUE;
		public var peopleCount: int = int.MIN_VALUE;
		public var playerGroup: int = int.MIN_VALUE;
		public var heroCardId: String;
		public var playerList: Vector.<PlayerParameter> = new Vector.<PlayerParameter>();
		
		public function Receive_BattleRoom_InitRoomDataLogicServer()
		{
			super(SocketContextConfig.BATTLEROOM_INIT_ROOM_LOGICSERVER);
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
							else if(playerGroup == int.MIN_VALUE)
							{
								playerGroup = data.readInt();
							}
							else if(parameter.level == int.MIN_VALUE)
							{
								parameter.level = data.readInt();
							}
							else if(parameter.group == int.MIN_VALUE)
							{
								parameter.group = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_LONG:
							if (parameter.accountId == null)
							{
								parameter.accountId = new UInt64();
								parameter.accountId.high = data.readInt();
								parameter.accountId.low = data.readUnsignedInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if(StringUtils.empty(heroCardId))
							{
								heroCardId = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.guid))
							{
								parameter.guid = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.name))
							{
								parameter.name = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(parameter.heroCardId))
							{
								parameter.heroCardId = data.readUTFBytes(length);
							}
							break;
					}
					
					if(!StringUtils.empty(parameter.guid) &&
						parameter.accountId != null &&
						!StringUtils.empty(parameter.name) &&
						parameter.level != int.MIN_VALUE &&
						parameter.heroCardId != null &&
						parameter.group != int.MIN_VALUE)
					{
						playerList.push(parameter);
						parameter = new PlayerParameter();
					}
				}
			}
		}
	}
}