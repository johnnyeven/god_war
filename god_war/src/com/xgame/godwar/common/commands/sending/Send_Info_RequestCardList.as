package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_RequestCardList extends SendingBase
	{
		public function Send_Info_RequestCardList()
		{
			super(SocketContextConfig.INFO_REQUEST_CARD_LIST);
		}
	}
}