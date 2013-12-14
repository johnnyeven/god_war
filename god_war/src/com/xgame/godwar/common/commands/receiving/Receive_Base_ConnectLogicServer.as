package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_Base_ConnectLogicServer extends ReceivingBase
	{
		public function Receive_Base_ConnectLogicServer()
		{
			super(SocketContextConfig.BASE_CONNECT_LOGIC_SERVER);
		}
	}
}