package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_LogicServerBindSession extends SendingBase
	{
		public var guid: String;
		
		public function Send_Info_LogicServerBindSession()
		{
			super(SocketContextConfig.INFO_LOGICSERVER_BIND_SESSION);
		}
		
		override public function fill():void 
		{
			super.fill();
			
			_byteData.writeInt(guid.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(guid);
		}
	}
}