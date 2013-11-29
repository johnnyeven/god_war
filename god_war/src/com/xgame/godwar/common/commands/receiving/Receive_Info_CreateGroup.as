package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Info_CreateGroup extends ReceivingBase
	{
		public var groupId: int = int.MIN_VALUE;
		public var groupName: String = null;
		
		public function Receive_Info_CreateGroup()
		{
			super(SocketContextConfig.INFO_CREATE_GROUP);
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
							if(groupId == int.MIN_VALUE)
							{
								groupId = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if (StringUtils.empty(groupName))
							{
								groupName = data.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}