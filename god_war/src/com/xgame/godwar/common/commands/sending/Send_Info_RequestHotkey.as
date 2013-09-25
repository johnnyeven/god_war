package com.xgame.godwar.common.commands.sending
{
	import com.xgame.configuration.SocketContextConfig;
	import com.xgame.utils.Int64;

	public class Send_Info_RequestHotkey extends SendingBase
	{
		public var accountId: Int64;
		
		public function Send_Info_RequestHotkey()
		{
			super(SocketContextConfig.REQUEST_HOTKEY);
		}
		
		override public function fill():void
		{
			super.fill();
			
			if(accountId != null)
			{
				_byteData.writeInt(8);
				_byteData.writeByte(SocketContextConfig.TYPE_LONG);
				_byteData.writeInt(accountId.high);
				_byteData.writeUnsignedInt(accountId.low);
			}
		}
		
		override public function get protocolName():String
		{
			return "Send_Info_RequestHotkey";
		}
	}
}