package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_DeleteGroup extends SendingBase
	{
		public var groupId: int = int.MIN_VALUE;
		
		public function Send_Info_DeleteGroup()
		{
			super(SocketContextConfig.INFO_DELETE_GROUP);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(groupId);
		}
	}
}