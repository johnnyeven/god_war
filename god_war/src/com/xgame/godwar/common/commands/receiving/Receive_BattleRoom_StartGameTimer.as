package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_StartGameTimer extends ReceivingBase
	{
		public function Receive_BattleRoom_StartGameTimer()
		{
			super(SocketContextConfig.BATTLEROOM_START_BATTLE_TIMER);
		}
	}
}