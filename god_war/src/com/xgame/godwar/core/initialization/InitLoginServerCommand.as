package com.xgame.godwar.core.initialization
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class InitLoginServerCommand extends SimpleCommand
	{
		public static const NAME: String = "InitLoginServerCommand";
		public static const LOAD_SERVER_NOTE: String = "InitLoginServerCommand.LoadServerNote";
		
		public function InitLoginServerCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/login_server.xml", {name:"loginServerConfig", onComplete:onLoadComplete, onProgress: onLoadProgress, onError: onLoadIOError});
			_loader.load();
			facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_loagin_server_config"));
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			var _config: XML = (evt.currentTarget as XMLLoader).content;;
			
			if(_config.hasOwnProperty("server"))
			{
				SocketContextConfig.login_ip = _config.server[0].@ip;
				SocketContextConfig.login_port = parseInt(_config.server[0].@port);
				
				facade.removeCommand(LOAD_SERVER_NOTE);
				facade.registerCommand(InitLoginSocketCommand.CONNECT_SOCKET_NOTE, InitLoginSocketCommand);
				
				facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
				facade.sendNotification(InitLoginSocketCommand.CONNECT_SOCKET_NOTE);
			}
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
		
		private function onLoadIOError(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, evt.text);
		}
	}
}