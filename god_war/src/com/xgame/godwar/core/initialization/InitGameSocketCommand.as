package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.controllers.RequestAccountRoleCommand;
	import com.xgame.godwar.core.login.controllers.RequestBindSessionCommand;
	import com.xgame.godwar.core.login.mediators.ServerMediator;
	import com.xgame.godwar.events.net.CommandEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitGameSocketCommand extends SimpleCommand
	{
		public static const CONNECT_SOCKET_NOTE: String = "InitGameSocketCommand.ConnectSocketNote";
		
		public function InitGameSocketCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _parameter: ServerListParameter = notification.getBody() as ServerListParameter;
			
			if(_parameter != null)
			{
				SocketContextConfig.server_ip = _parameter.ip;
				SocketContextConfig.server_port = _parameter.port;
			}
			
			var _commandCenter: CommandCenter = CommandCenter.instance;
			_commandCenter.dispose();
			_commandCenter = CommandCenter.instance;
			_commandCenter.addEventListener(CommandEvent.CLOSED_EVENT, onClosed);
			_commandCenter.addEventListener(CommandEvent.CONNECTED_EVENT, onConnected);
			_commandCenter.addEventListener(CommandEvent.IOERROR_EVENT, onIOError);
			_commandCenter.addEventListener(CommandEvent.SECURITYERROR_EVENT, onSecurityError);
			_commandCenter.connect(SocketContextConfig.server_ip, SocketContextConfig.server_port);
			
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
			facade.sendNotification(ServerMediator.HIDE_NOTE);
			
			if(!facade.hasCommand(RequestBindSessionCommand.NAME))
			{
				facade.registerCommand(RequestBindSessionCommand.NAME, RequestBindSessionCommand);
			}
			facade.sendNotification(RequestBindSessionCommand.NAME);
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