package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_ChangeFormation extends ReceivingBase
	{
		public var guid: String;
		public var position: int = int.MIN_VALUE;
		public var cardOut: String;
		public var cardIn: String;
		
		public function Receive_BattleRoom_ChangeFormation()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CHANGE_FORMATION);
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
							else if(StringUtils.empty(cardOut))
							{
								cardOut = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(cardIn))
							{
								cardIn = data.readUTFBytes(length);
							}
							break;
						case SocketContextConfig.TYPE_INT:
							if(position == int.MIN_VALUE)
							{
								position = data.readInt();
							}
							break;
					}
				}
			}
		}
	}
}