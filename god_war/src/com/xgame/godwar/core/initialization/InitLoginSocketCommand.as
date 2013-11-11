package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.ShowLoginMediatorCommand;
	import com.xgame.godwar.core.login.controllers.ShowRegisterMediatorCommand;
	import com.xgame.godwar.core.login.controllers.ShowStartMediatorCommand;
	import com.xgame.godwar.events.net.CommandEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitLoginSocketCommand extends SimpleCommand
	{
		public static const NAME: String = "InitLoginSocketCommand";
		public static const CONNECT_SOCKET_NOTE: String = "InitLoginSocketCommand.ConnectSocketNote";
		
		public function InitLoginSocketCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _commandCenter: CommandCenter = CommandCenter.instance;
			_commandCenter.dispose();
			_commandCenter = CommandCenter.instance;
			_commandCenter.addEventListener(CommandEvent.CLOSED_EVENT, onClosed);
			_commandCenter.addEventListener(CommandEvent.CONNECTED_EVENT, onConnected);
			_commandCenter.addEventListener(CommandEvent.IOERROR_EVENT, onIOError);
			_commandCenter.addEventListener(CommandEvent.SECURITYERROR_EVENT, onSecurityError);
			_commandCenter.connect(SocketContextConfig.login_ip, SocketContextConfig.login_port);
			
			facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
		}
		
		private function onClosed(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
		}
		
		private function onConnected(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			facade.registerCommand(ShowStartMediatorCommand.CREATE_LOGIN_VIEW_NOTE, ShowStartMediatorCommand);
			facade.registerCommand(ShowLoginMediatorCommand.SHOW_NOTE, ShowLoginMediatorCommand);
			facade.registerCommand(ShowRegisterMediatorCommand.SHOW_NOTE, ShowRegisterMediatorCommand);
			facade.sendNotification(ShowStartMediatorCommand.CREATE_LOGIN_VIEW_NOTE);
		}
		
		private function onIOError(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			onConnected(event);
		}
		
		private function onSecurityError(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
		}
	}
}