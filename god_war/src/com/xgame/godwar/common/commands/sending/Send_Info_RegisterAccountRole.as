package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.Int64;

	public class Send_Info_RegisterAccountRole extends SendingBase
	{
		public var GUID: Int64;
		public var nickName: String;
		
		public function Send_Info_RegisterAccountRole()
		{
			super(SocketContextConfig.REGISTER_ACCOUNT_ROLE);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(8);
			_byteData.writeByte(SocketContextConfig.TYPE_LONG);
			_byteData.writeInt(GUID.high);
			_byteData.writeUnsignedInt(GUID.low);
			
			_byteData.writeInt(nickName.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(nickName);
		}
	}
}