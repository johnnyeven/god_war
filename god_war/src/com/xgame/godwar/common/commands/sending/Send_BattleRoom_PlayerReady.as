package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_PlayerReady extends SendingBase
	{
		public var ready: int = 0;
		
		public function Send_BattleRoom_PlayerReady()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_READY);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(ready);
		}
	}
}