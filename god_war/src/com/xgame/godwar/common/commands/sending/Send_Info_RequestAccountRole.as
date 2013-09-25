package com.xgame.godwar.common.commands.sending
{
	import com.xgame.configuration.SocketContextConfig;
	import com.xgame.utils.Int64;

	public class Send_Info_RequestAccountRole extends SendingBase
	{
		public var GUID: Int64;
		
		public function Send_Info_RequestAccountRole()
		{
			super(SocketContextConfig.REQUEST_ACCOUNT_ROLE);
		}
		
		override public function fill():void 
		{
			super.fill();
			
			_byteData.writeInt(8);
			_byteData.writeByte(SocketContextConfig.TYPE_LONG);
			_byteData.writeInt(GUID.high);
			_byteData.writeUnsignedInt(GUID.low);
		}
		
		override public function get protocolName():String
		{
			return "Send_Info_RequestAccountRole";
		}
	}
}