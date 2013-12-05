package com.xgame.godwar.core.login.proxy
{
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_Account;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.commands.sending.Send_Info_RegisterAccountRole;
	import com.xgame.godwar.common.commands.sending.Send_Info_RequestAccountRole;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.initialization.LoadAvatarConfigCommand;
	import com.xgame.godwar.core.initialization.LoadInitDataCommand;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.ShowChooseModeMediatorCommand;
	import com.xgame.godwar.core.login.controllers.ShowCreateRoleMediatorCommand;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	import com.xgame.godwar.core.login.proxy.LoginProxy;
	import com.xgame.godwar.utils.Int64;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RequestRoleProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "RequestRoleProxy";
		
		public var accountId: Int64;
		
		public function RequestRoleProxy(data:Object=null)
		{
			super(NAME, data);
			
			facade.registerCommand(ShowChooseModeMediatorCommand.SHOW_NOTE, ShowChooseModeMediatorCommand);
		}
		
		public function requestAccountRole(): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Receive_Info_Account = facade.retrieveProxy(LoginProxy.NAME).getData() as Receive_Info_Account;
				if(protocol != null || protocol.GUID != null)
				{
					sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
					
					CommandList.instance.bind(SocketContextConfig.REQUEST_ACCOUNT_ROLE, Receive_Info_AccountRole);
					CommandCenter.instance.add(SocketContextConfig.REQUEST_ACCOUNT_ROLE, onRequestAccountRole);
					
					var data: Send_Info_RequestAccountRole = new Send_Info_RequestAccountRole();
					data.GUID = protocol.GUID;
					CommandCenter.instance.send(data);
				}
			}
		}
		
		private function onRequestAccountRole(protocol: Receive_Info_AccountRole): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			facade.registerCommand(LoadAvatarConfigCommand.LOAD_NOTE, LoadAvatarConfigCommand);
			
			setData(protocol);
			accountId = protocol.accountId;
			
			if(protocol.accountId.toNumber() == -1)
			{
				facade.registerCommand(ShowCreateRoleMediatorCommand.SHOW_CREATE_ROLE_NOTE, ShowCreateRoleMediatorCommand);
				facade.sendNotification(ShowCreateRoleMediatorCommand.SHOW_CREATE_ROLE_NOTE);
			}
			else
			{
				facade.sendNotification(LoadAvatarConfigCommand.LOAD_NOTE);
				facade.sendNotification(CreateRoleMediator.DISPOSE_NOTE);
				facade.sendNotification(ShowChooseModeMediatorCommand.SHOW_NOTE);
			}
		}
		
		public function registerAccountRole(roleName: String): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Receive_Info_Account = facade.retrieveProxy(LoginProxy.NAME).getData() as Receive_Info_Account;
				if(protocol != null || protocol.GUID != null)
				{
					sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
					
					CommandList.instance.bind(SocketContextConfig.REGISTER_ACCOUNT_ROLE, Receive_Info_AccountRole);
					CommandCenter.instance.add(SocketContextConfig.REGISTER_ACCOUNT_ROLE, onRegisterAccountRole);
					
					var data: Send_Info_RegisterAccountRole = new Send_Info_RegisterAccountRole();
					data.GUID = protocol.GUID;
					data.nickName = roleName;
					CommandCenter.instance.send(data);
				}
			}
		}
		
		private function onRegisterAccountRole(protocol: Receive_Info_AccountRole): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			setData(protocol);
			accountId = protocol.accountId;
			facade.sendNotification(CreateRoleMediator.DISPOSE_NOTE);
			facade.sendNotification(ShowChooseModeMediatorCommand.SHOW_NOTE);
		}
	}
}