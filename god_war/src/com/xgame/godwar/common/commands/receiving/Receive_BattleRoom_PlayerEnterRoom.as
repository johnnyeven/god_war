package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_PlayerEnterRoom extends ReceivingBase
	{
		public function Receive_BattleRoom_PlayerEnterRoom()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM);
		}
	}
}