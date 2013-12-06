package com.xgame.godwar.core.general.proxy
{
	import com.xgame.godwar.common.commands.sending.Send_Info_HeartBeat;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class KeepAliveProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "KeepAliveProxy";
		private var sendProtocol: Send_Info_HeartBeat;
		
		public function KeepAliveProxy()
		{
			super(NAME, null);
			sendProtocol = new Send_Info_HeartBeat();
		}
		
		public function startHeatbeat(): void
		{
			TimerManager.instance.add(5000, onHeartbeat);
		}
		
		public function stopHearbeat(): void
		{
			TimerManager.instance.remove(onHeartbeat);
		}
		
		private function onHeartbeat(): void
		{
			if(CommandCenter.instance.connected)
			{
				CommandCenter.instance.send(sendProtocol);
			}
		}
	}
}