package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.RequestBindSessionCommand;
	import com.xgame.godwar.core.login.controllers.RequestLogicServerBindSessionCommand;
	import com.xgame.godwar.events.net.CommandEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitLogicSocketCommand extends SimpleCommand
	{
		public static const CONNECT_SOCKET_NOTE: String = "InitLogicSocketCommand.ConnectSocketNote";
		
		public function InitLogicSocketCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _parameter: ServerListParameter = notification.getBody() as ServerListParameter;
			
			if(_parameter != null)
			{
				SocketContextConfig.logic_ip = _parameter.ip;
				SocketContextConfig.logic_port = _parameter.port;
			}
			
			var _commandCenter: CommandCenter = CommandCenter.instance;
			_commandCenter.dispose();
			_commandCenter = CommandCenter.instance;
			_commandCenter.addEventListener(CommandEvent.CLOSED_EVENT, onClosed);
			_commandCenter.addEventListener(CommandEvent.CONNECTED_EVENT, onConnected);
			_commandCenter.addEventListener(CommandEvent.IOERROR_EVENT, onIOError);
			_commandCenter.addEventListener(CommandEvent.SECURITYERROR_EVENT, onSecurityError);
			_commandCenter.connect(SocketContextConfig.logic_ip, SocketContextConfig.logic_port);
			
			facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
		}
		
		private function onClosed(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
		}
		
		private function onConnected(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			if(!facade.hasCommand(RequestLogicServerBindSessionCommand.NAME))
			{
				facade.registerCommand(RequestLogicServerBindSessionCommand.NAME, RequestLogicServerBindSessionCommand);
			}
			facade.sendNotification(RequestLogicServerBindSessionCommand.NAME);
		}
		
		private function onIOError(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
		}
		
		private function onSecurityError(event: CommandEvent): void
		{
			facade.removeCommand(CONNECT_SOCKET_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
		}
	}
}