package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_CreateGroup extends SendingBase
	{
		public var groupName: String = null;
		
		public function Send_Info_CreateGroup()
		{
			super(SocketContextConfig.INFO_CREATE_GROUP);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(groupName.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(groupName);
		}
	}
}