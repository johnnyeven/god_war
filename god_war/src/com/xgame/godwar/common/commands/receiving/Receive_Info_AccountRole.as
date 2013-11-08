package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.Int64;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UInt64;
	
	import flash.utils.ByteArray;

	public class Receive_Info_AccountRole extends ReceivingBase
	{
		public var guid: String;
		public var accountId: Int64;
		public var nickName: String;
		public var level: int;
		public var accountCash: Int64;
		public var rolePicture: String;
		
		public function Receive_Info_AccountRole()
		{
			super(SocketContextConfig.REGISTER_ACCOUNT_ROLE);
			level = int.MIN_VALUE;
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
						case SocketContextConfig.TYPE_LONG:
							if (accountId == null)
							{
								accountId = new Int64();
								accountId.high = data.readInt();
								accountId.low = data.readUnsignedInt();
							}
							else if(accountCash == null)
							{
								accountCash = new Int64();
								accountCash.high = data.readInt();
								accountCash.low = data.readUnsignedInt();
							}
							break;
						case SocketContextConfig.TYPE_STRING:
							if(StringUtils.empty(guid))
							{
								guid = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(nickName))
							{
								nickName = data.readUTFBytes(length);
							}
							else if(StringUtils.empty(rolePicture))
							{
								rolePicture = data.readUTFBytes(length);
							}
							break;
						case SocketContextConfig.TYPE_INT:
							if(level == int.MIN_VALUE)
							{
								level = data.readInt();
							}
							break;
					}
				}
			}
		}
	}
}