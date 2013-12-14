package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	
	import flash.utils.ByteArray;

	public class Receive_Info_LogicServerBindSession extends ReceivingBase
	{
		public var result: int = int.MIN_VALUE;
		
		public function Receive_Info_LogicServerBindSession()
		{
			super(SocketContextConfig.INFO_LOGICSERVER_BIND_SESSION);
		}
		
		override public function fill(bytes: ByteArray):void
		{
			super.fill(bytes);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				while (bytes.bytesAvailable > 8)
				{
					length = bytes.readInt();
					type = bytes.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if (result == int.MIN_VALUE)
							{
								result = bytes.readInt();
							}
							break;
					}
				}
			}
		}
	}
}