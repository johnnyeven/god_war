package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_HeartBeat extends SendingBase
	{
		public function Send_Info_HeartBeat()
		{
			super(SocketContextConfig.INFO_HEART_BEAT);
		}
	}
}