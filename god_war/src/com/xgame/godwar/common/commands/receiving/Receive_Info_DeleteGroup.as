package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	
	import flash.utils.ByteArray;

	public class Receive_Info_DeleteGroup extends ReceivingBase
	{
		public var groupId: int = int.MIN_VALUE;
		
		public function Receive_Info_DeleteGroup()
		{
			super(SocketContextConfig.INFO_DELETE_GROUP);
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
					}
				}
			}
		}
	}
}