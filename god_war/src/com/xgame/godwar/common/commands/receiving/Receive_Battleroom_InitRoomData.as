package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_Battleroom_InitRoomData extends ReceivingBase
	{
		public function Receive_Battleroom_InitRoomData()
		{
			super(SocketContextConfig.BATTLEROOM_INIT_ROOM);
		}
	}
}