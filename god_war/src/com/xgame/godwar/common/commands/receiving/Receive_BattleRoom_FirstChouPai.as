package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_FirstChouPai extends ReceivingBase
	{
		public var soulCardList: Array;
		
		public function Receive_BattleRoom_FirstChouPai()
		{
			super(SocketContextConfig.BATTLEROOM_FIRST_CHOUPAI);
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
							if (soulCardList == null)
							{
								var soulCardString: String = data.readUTFBytes(length);
								soulCardList = soulCardString.split(",");
							}
							break;
					}
				}
			}
		}
	}
}