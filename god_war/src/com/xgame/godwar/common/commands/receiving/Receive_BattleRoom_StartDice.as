package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Receive_BattleRoom_StartDice extends ReceivingBase
	{
		public var parameter: Dictionary;
		private var guid: String;
		private var value: int = int.MIN_VALUE;
		
		public function Receive_BattleRoom_StartDice()
		{
			super(SocketContextConfig.BATTLEROOM_START_DICE);
			
			parameter = new Dictionary();
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
						case SocketContextConfig.TYPE_INT:
							if (value == int.MIN_VALUE)
							{
								value = data.readInt();
							}
							break;
					}
					if(!StringUtils.empty(guid) && value > 0)
					{
						parameter[guid] = value;
						guid = "";
						value = int.MIN_VALUE;
					}
				}
			}
		}
	}
}