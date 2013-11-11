package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_Register extends SendingBase
	{
		public var userName: String;
		public var userPass: String;
		
		public function Send_Info_Register()
		{
			super(SocketContextConfig.INFO_REGISTER);
		}
		
		override public function fill():void 
		{
			super.fill();
			
			_byteData.writeInt(userName.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(userName);
			
			_byteData.writeInt(userPass.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(userPass);
		}
	}
}