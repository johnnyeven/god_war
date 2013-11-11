package com.xgame.godwar.core.login.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_Account;
	import com.xgame.godwar.common.commands.sending.Send_Info_Login;
	import com.xgame.godwar.common.commands.sending.Send_Info_QuickStart;
	import com.xgame.godwar.common.commands.sending.Send_Info_Register;
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.ShowLoginMediatorCommand;
	import com.xgame.godwar.core.login.controllers.ShowRegisterMediatorCommand;
	import com.xgame.godwar.core.login.controllers.ShowServerMediatorCommand;
	import com.xgame.godwar.core.login.mediators.LoginBGMediator;
	import com.xgame.godwar.core.login.mediators.StartMediator;
	import com.xgame.godwar.utils.StringUtils;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "LoginProxy";
		
		public function LoginProxy(data:Object=null)
		{
			super(NAME, data);
			
			CommandList.instance.bind(SocketContextConfig.QUICK_START, Receive_Info_Account);
			CommandCenter.instance.add(SocketContextConfig.QUICK_START, onAccount);
			
			CommandList.instance.bind(SocketContextConfig.INFO_LOGIN, Receive_Info_Account);
			CommandCenter.instance.add(SocketContextConfig.INFO_LOGIN, onAccountLogin);
			
			CommandList.instance.bind(SocketContextConfig.INFO_REGISTER, Receive_Info_Account);
			CommandCenter.instance.add(SocketContextConfig.INFO_REGISTER, onAccountRegister);
		}
		
		public function quickStart(): void
		{
			if(CommandCenter.instance.connected)
			{
				sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				
				var _protocol: Send_Info_QuickStart = new Send_Info_QuickStart();
				_protocol.GameId = GlobalContextConfig.GameId;
				CommandCenter.instance.send(_protocol);
			}
		}
		
		public function login(userName: String, userPass: String): void
		{
			if(CommandCenter.instance.connected && !StringUtils.empty(userName) && !StringUtils.empty(userPass))
			{
				sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				
				var _protocol: Send_Info_Login = new Send_Info_Login();
				_protocol.userName = userName;
				_protocol.userPass = userPass;
				CommandCenter.instance.send(_protocol);
			}
		}
		
		public function register(userName: String, userPass: String): void
		{
			if(CommandCenter.instance.connected && !StringUtils.empty(userName) && !StringUtils.empty(userPass))
			{
				sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				
				var _protocol: Send_Info_Register = new Send_Info_Register();
				_protocol.userName = userName;
				_protocol.userPass = userPass;
				CommandCenter.instance.send(_protocol);
			}
		}
		
		private function onAccount(protocol: Receive_Info_Account): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			facade.registerCommand(ShowServerMediatorCommand.CREATE_NOTE, ShowServerMediatorCommand);
			sendNotification(ShowServerMediatorCommand.CREATE_NOTE);
			
			setData(protocol);
		}
		
		private function onAccountLogin(protocol: Receive_Info_Account): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			if(protocol.flag == -1)
			{
				facade.sendNotification(ShowLoginMediatorCommand.SHOW_NOTE);
				return;
			}
			facade.registerCommand(ShowServerMediatorCommand.CREATE_NOTE, ShowServerMediatorCommand);
			sendNotification(ShowServerMediatorCommand.CREATE_NOTE);
			
			setData(protocol);
		}
		
		private function onAccountRegister(protocol: Receive_Info_Account): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			if(protocol.flag == -1)
			{
				facade.sendNotification(ShowRegisterMediatorCommand.SHOW_NOTE);
				return;
			}
			facade.registerCommand(ShowServerMediatorCommand.CREATE_NOTE, ShowServerMediatorCommand);
			sendNotification(ShowServerMediatorCommand.CREATE_NOTE);
			
			setData(protocol);
		}
	}
}