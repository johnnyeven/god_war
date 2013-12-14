package com.xgame.godwar.core.login.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_BindSession;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_Account;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_LogicServerBindSession;
	import com.xgame.godwar.common.commands.sending.Send_Info_BindSession;
	import com.xgame.godwar.common.commands.sending.Send_Info_LogicServerBindSession;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.proxy.KeepAliveProxy;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.RequestAccountRoleCommand;
	import com.xgame.godwar.utils.debug.Debug;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SessionProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "SessionProxy";

		public function SessionProxy()
		{
			super(NAME);
		}
		
		public function requestBindSession(): void
		{
			var _proxy: LoginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			if(_proxy != null)
			{
				var _protocol: Receive_Info_Account = _proxy.getData() as Receive_Info_Account;
				if(_protocol != null)
				{
					if(CommandCenter.instance.connected)
					{
						sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
						
						CommandList.instance.bind(SocketContextConfig.INFO_BIND_SESSION, Receive_BindSession);
						CommandCenter.instance.add(SocketContextConfig.INFO_BIND_SESSION, onBindSession);
						
						var _send: Send_Info_BindSession = new Send_Info_BindSession();
						_send.accountName = _protocol.accountName;
						CommandCenter.instance.send(_send);
					}
				}
				else
				{
					Debug.error(this, "LoginProxy.getData()为空，用户数据不存在");
				}
			}
			else
			{
				Debug.error(this, "LoginProxy未注册");
			}
		}
		
		private function onBindSession(protocol: Receive_BindSession): void
		{
			if(protocol.result == 1)
			{
				setData(protocol);
				
				if(!facade.hasProxy(KeepAliveProxy.NAME))
				{
					var proxy: KeepAliveProxy = new KeepAliveProxy();
					facade.registerProxy(proxy);
					proxy.startHeatbeat();
				}
				
				if(!facade.hasCommand(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE))
				{
					facade.registerCommand(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE, RequestAccountRoleCommand);
				}
				facade.sendNotification(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE);
			}
		}
		
		public function requestLogicServerBindSession(): void
		{
			var _proxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(_proxy != null)
			{
				var _protocol: Receive_Info_AccountRole = _proxy.getData() as Receive_Info_AccountRole;
				if(_protocol != null)
				{
					if(CommandCenter.instance.connected)
					{
						sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
						
						CommandList.instance.bind(SocketContextConfig.INFO_LOGICSERVER_BIND_SESSION, Receive_Info_LogicServerBindSession);
						CommandCenter.instance.add(SocketContextConfig.INFO_LOGICSERVER_BIND_SESSION, onLogicServerBindSession);
						
						var _send: Send_Info_LogicServerBindSession = new Send_Info_LogicServerBindSession();
						_send.guid = _protocol.guid;
						CommandCenter.instance.send(_send);
					}
				}
				else
				{
					Debug.error(this, "LoginProxy.getData()为空，用户数据不存在");
				}
			}
			else
			{
				Debug.error(this, "LoginProxy未注册");
			}
		}
		
		private function onLogicServerBindSession(protocol: Receive_Info_LogicServerBindSession): void
		{
			if(protocol.result == 1)
			{
				facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
				
//				if(!facade.hasProxy(KeepAliveProxy.NAME))
//				{
//					var proxy: KeepAliveProxy = new KeepAliveProxy();
//					facade.registerProxy(proxy);
//					proxy.startHeatbeat();
//				}
				
//				if(!facade.hasCommand(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE))
//				{
//					facade.registerCommand(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE, RequestAccountRoleCommand);
//				}
//				facade.sendNotification(RequestAccountRoleCommand.REQUEST_ACCOUNT_ROLE_NOTE);
			}
		}
	}
}