package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Hall_RequestCardGroup extends SendingBase
	{
		public function Send_Hall_RequestCardGroup()
		{
			super(SocketContextConfig.INFO_REQUEST_CARD_GROUP);
		}
	}
}