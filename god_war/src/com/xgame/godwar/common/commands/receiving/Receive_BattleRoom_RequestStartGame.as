package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_RequestStartGame extends ReceivingBase
	{
		public function Receive_BattleRoom_RequestStartGame()
		{
			super(SocketContextConfig.BATTLEROOM_REQUEST_START_BATTLE);
		}
	}
}