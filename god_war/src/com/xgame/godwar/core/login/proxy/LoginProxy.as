package com.xgame.godwar.core.login.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_QuickStart;
	import com.xgame.godwar.common.commands.sending.Send_Info_QuickStart;
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.ShowServerMediatorCommand;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "LoginProxy";
		
		public function LoginProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function quickStart(): void
		{
			if(CommandCenter.instance.connected)
			{
				sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				
				CommandList.instance.bind(SocketContextConfig.QUICK_START, Receive_Info_QuickStart);
				CommandCenter.instance.add(SocketContextConfig.QUICK_START, onQuickStart);
				
				var _protocol: Send_Info_QuickStart = new Send_Info_QuickStart();
				_protocol.GameId = GlobalContextConfig.GameId;
				CommandCenter.instance.send(_protocol);
			}
		}
		
		private function onQuickStart(protocol: Receive_Info_QuickStart): void
		{
			facade.registerCommand(ShowServerMediatorCommand.CREATE_NOTE, ShowServerMediatorCommand);
			
			setData(protocol);
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			sendNotification(ShowServerMediatorCommand.CREATE_NOTE);
		}
	}
}