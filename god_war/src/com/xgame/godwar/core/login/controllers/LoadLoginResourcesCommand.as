package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.initialization.InitLoginServerCommand;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadLoginResourcesCommand extends SimpleCommand
	{
		public static const LOAD_LOGIN_RESOURCE_NOTE: String = "LoadLoginResourcesCommand.LoadLoginResourceNote";
		
		public function LoadLoginResourcesCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			ResourceCenter.instance.load("login_ui_batch", null, onLoadComplete, onLoadProgress, onLoadIOError);
			facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_loagin_ui"));
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			facade.removeCommand(LOAD_LOGIN_RESOURCE_NOTE);
			facade.registerCommand(InitLoginServerCommand.LOAD_SERVER_NOTE, InitLoginServerCommand);
			
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			facade.sendNotification(InitLoginServerCommand.LOAD_SERVER_NOTE);
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