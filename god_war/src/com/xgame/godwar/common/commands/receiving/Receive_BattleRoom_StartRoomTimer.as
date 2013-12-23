package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_StartRoomTimer extends ReceivingBase
	{
		public function Receive_BattleRoom_StartRoomTimer()
		{
			super(SocketContextConfig.BATTLEROOM_START_ROOM_TIMER);
		}
	}
}