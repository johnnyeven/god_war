package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PlayerSelectHero extends ReceivingBase
	{
		public var guid: String;
		public var lastCardId: String;
		public var cardId: String;
		
		public function Receive_BattleRoom_PlayerSelectHero()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_SELECTED_HERO);
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
						case SocketContextConfig.TYPE_STRING:
							if (StringUtils.empty(guid))
							{
								guid = data.readUTFBytes(length);
							}
							else if(lastCardId == null)
							{
								lastCardId = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(cardId))
							{
								cardId = data.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}