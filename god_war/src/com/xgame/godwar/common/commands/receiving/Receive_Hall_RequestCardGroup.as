package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.utils.ByteArray;

	public class Receive_Hall_RequestCardGroup extends ReceivingBase
	{
		public var list: Vector.<CardGroupParameter>;
		
		public function Receive_Hall_RequestCardGroup()
		{
			super(SocketContextConfig.INFO_REQUEST_CARD_GROUP);
			list = new Vector.<CardGroupParameter>();
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				var parameter: CardGroupParameter = new CardGroupParameter();
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if (parameter.groupId == int.MIN_VALUE)
							{
								parameter.groupId = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if (StringUtils.empty(parameter.groupName))
							{
								parameter.groupName = data.readUTFBytes(length);
							}
							else if(!parameter.cardListReady)
							{
								parameter.cards = data.readUTFBytes(length);
							}
							break;
					}
					
					if(parameter.groupId != int.MIN_VALUE &&
						!StringUtils.empty(parameter.groupName) &&
						parameter.cardListReady)
					{
						list.push(parameter);
						parameter = new CardGroupParameter();
					}
				}
			}
		}
	}
}