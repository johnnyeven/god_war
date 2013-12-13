package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_StartBattle extends SendingBase
	{
		public var roomId: int;
		
		public function Send_BattleRoom_StartBattle()
		{
			super(SocketContextConfig.BATTLEROOM_REQUEST_START_BATTLE);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(0);
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(roomId);
		}
	}
}