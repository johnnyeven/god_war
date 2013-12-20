package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UInt64;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PlayerEnterRoomLogicServer extends ReceivingBase
	{
		public var guid: String;
		public var accountId: UInt64;
		public var name: String;
		public var level: int = int.MIN_VALUE;
		public var heroCardId: String;
		public var group: int = int.MIN_VALUE;
		
		public function Receive_BattleRoom_PlayerEnterRoomLogicServer()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM_LOGICSERVER);
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
							else if(StringUtils.empty(heroCardId))
							{
								heroCardId = data.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}