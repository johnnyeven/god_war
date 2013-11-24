package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Info_RequestCardList extends ReceivingBase
	{
		public var cardList: String = null;
		
		public function Receive_Info_RequestCardList()
		{
			super(SocketContextConfig.INFO_REQUEST_CARD_LIST);
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
							if (StringUtils.empty(cardList))
							{
								cardList = data.readUTFBytes(length);
							}
							break;
					}
				}
			}
		}
	}
}