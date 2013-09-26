package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Info_RequestHotkey extends ReceivingBase
	{
		public var config: XML;
		
		public function Receive_Info_RequestHotkey()
		{
			super(SocketContextConfig.REQUEST_HOTKEY);
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if(message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				while(data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_STRING:
							var s: String = data.readUTFBytes(length);
							if(!StringUtils.empty(s))
							{
								config = XML(s);
							}
							break;
					}
				}
			}
		}
	}
}