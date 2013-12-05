package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UInt64;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PlayerEnterRoom extends ReceivingBase
	{
		public var guid: String;
		public var accountId: UInt64;
		public var name: String;
		public var level: int = int.MIN_VALUE;
		public var avatarId: String;
		public var cash: UInt64;
		public var winningCount: int = int.MIN_VALUE;
		public var battleCount: int = int.MIN_VALUE;
		public var honor: int = int.MIN_VALUE;
		public var playerStatus: int = int.MIN_VALUE;
		public var group: int = int.MIN_VALUE;
		
		public function Receive_BattleRoom_PlayerEnterRoom()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM);
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
							if(level == int.MIN_VALUE)
							{
								level = data.readInt();
							}
							else if(winningCount == int.MIN_VALUE)
							{
								winningCount = data.readInt();
							}
							else if(battleCount == int.MIN_VALUE)
							{
								battleCount = data.readInt();
							}
							else if(honor == int.MIN_VALUE)
							{
								honor = data.readInt();
							}
							else if(playerStatus == int.MIN_VALUE)
							{
								playerStatus = data.readInt();
							}
							else if(group == int.MIN_VALUE)
							{
								group = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_LONG:
							if (accountId == null)
							{
								accountId = new UInt64();
								accountId.high = data.readInt();
								accountId.low = data.readUnsignedInt();
							}
							else if(cash == null)
							{
								cash = new UInt64();
								cash.high = data.readInt();
								cash.low = data.readUnsignedInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if(StringUtils.empty(guid))
							{
								guid = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(name))
							{
								name = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(avatarId))
							{
								avatarId = data.readUTFBytes(length);
								if(StringUtils.empty(avatarId))
								{
									avatarId = "default";
								}
							}
							break;
					}
				}
			}
		}
	}
}