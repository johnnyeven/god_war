package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_Info_SaveCardConfig extends ReceivingBase
	{
		public function Receive_Info_SaveCardConfig()
		{
			super(SocketContextConfig.INFO_SAVE_CARD_GROUP);
		}
	}
}