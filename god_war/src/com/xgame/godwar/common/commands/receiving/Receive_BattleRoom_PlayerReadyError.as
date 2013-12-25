package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_PlayerReadyError extends ReceivingBase
	{
		public var flag: int = int.MIN_VALUE;
		
		public function Receive_BattleRoom_PlayerReadyError()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_READY_ERROR);
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
							if(flag == int.MIN_VALUE)
							{
								flag = data.readInt();
							}
							break;
					}
				}
			}
		}
	}
}