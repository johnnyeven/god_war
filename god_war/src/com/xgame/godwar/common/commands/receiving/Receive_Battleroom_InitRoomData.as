package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UInt64;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_InitRoomData extends ReceivingBase
	{
		public var roomId: int = int.MIN_VALUE;
		public var roomTitle: String;
		public var ownerGuid: String;
		public var ownerName: String;
		public var peopleCount: int = int.MIN_VALUE;
		public var peopleLimit: int = int.MIN_VALUE;
		public var playerGroup: int = int.MIN_VALUE;
		public var playerList: Vector.<PlayerParameter> = new Vector.<PlayerParameter>();
		
		public function Receive_BattleRoom_InitRoomData()
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
							else if(playerGroup == int.MIN_VALUE)
							{
								playerGroup = data.readInt();
							}
							else if(parameter.level == int.MIN_VALUE)
							{
								parameter.level = data.readInt();
							}
							else if(parameter.winningCount == int.MIN_VALUE)
							{
								parameter.winningCount = data.readInt();
							}
							else if(parameter.battleCount == int.MIN_VALUE)
							{
								parameter.battleCount = data.readInt();
							}
							else if(parameter.honor == int.MIN_VALUE)
							{
								parameter.honor = data.readInt();
							}
							else if(parameter.playerStatus == int.MIN_VALUE)
							{
								parameter.playerStatus = data.readInt();
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
							else if(parameter.cash == null)
							{
								parameter.cash = new UInt64();
								parameter.cash.high = data.readInt();
								parameter.cash.low = data.readUnsignedInt();
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
							else if(StringUtils.empty(parameter.avatarId))
							{
								parameter.avatarId = data.readUTFBytes(length);
								if(StringUtils.empty(parameter.avatarId))
								{
									parameter.avatarId = "default";
								}
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
						!StringUtils.empty(parameter.avatarId) &&
						parameter.heroCardId != null &&
						parameter.cash != null &&
						parameter.winningCount != int.MIN_VALUE &&
						parameter.battleCount != int.MIN_VALUE &&
						parameter.honor != int.MIN_VALUE &&
						parameter.playerStatus != int.MIN_VALUE &&
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