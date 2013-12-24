package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_FirstChouPai extends ReceivingBase
	{
		public function Receive_BattleRoom_FirstChouPai()
		{
			super(SocketContextConfig.BATTLEROOM_FIRST_CHOUPAI);
		}
	}
}