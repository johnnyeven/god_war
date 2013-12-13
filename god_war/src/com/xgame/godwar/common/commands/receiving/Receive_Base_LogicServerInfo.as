package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Base_LogicServerInfo extends ReceivingBase
	{
		public var ip: String;
		public var port: int = int.MIN_VALUE;
		
		public function Receive_Base_LogicServerInfo()
		{
			super(SocketContextConfig.BASE_LOGIC_SERVER_INFO);
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
							if(StringUtils.empty(ip))
							{
								ip = data.readUTFBytes(length);
							}
							break;
						case SocketContextConfig.TYPE_INT:
							if(port == int.MIN_VALUE)
							{
								port = data.readInt();
							}
					}
				}
			}
		}
	}
}