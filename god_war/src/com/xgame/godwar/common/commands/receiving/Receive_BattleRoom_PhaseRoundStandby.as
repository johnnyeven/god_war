package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PhaseRoundStandby extends ReceivingBase
	{
		public var guid: String;
		
		public function Receive_BattleRoom_PhaseRoundStandby()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_STANDBY);
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
							if(StringUtils.empty(guid))
							{
								guid = data.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}