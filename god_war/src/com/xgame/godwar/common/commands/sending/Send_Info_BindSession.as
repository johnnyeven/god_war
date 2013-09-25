package com.xgame.godwar.common.commands.sending
{
	import com.xgame.configuration.SocketContextConfig;

	public class Send_Info_BindSession extends SendingBase
	{
		public var accountName: String;
		
		public function Send_Info_BindSession()
		{
			super(SocketContextConfig.INFO_BIND_SESSION);
		}
		
		override public function fill():void 
		{
			super.fill();
			
			_byteData.writeInt(accountName.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(accountName);
		}
	}
}