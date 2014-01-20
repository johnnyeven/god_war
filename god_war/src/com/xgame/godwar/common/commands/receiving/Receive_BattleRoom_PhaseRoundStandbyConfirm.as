package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PhaseRoundStandbyConfirm extends ReceivingBase
	{
		public var soulCardList: Array;
		
		public function Receive_BattleRoom_PhaseRoundStandbyConfirm()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CONFIRM);
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