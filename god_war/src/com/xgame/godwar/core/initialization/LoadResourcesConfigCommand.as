package com.xgame.godwar.core.initialization
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.login.controllers.LoadLoginResourcesCommand;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadResourcesConfigCommand extends SimpleCommand
	{
		public static const LOAD_RESOURCE_CONFIG: String = "LoaderResourcesConfigCommand.LoadResourceConfig";
		
		public function LoadResourcesConfigCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/resources.xml", {name:"resourcesConfig", onComplete:onLoadComplete, onProgress: onLoadProgress, onError: onLoadIOError});
			_loader.load();
			facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_resource_config"));
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			facade.removeCommand(LOAD_RESOURCE_CONFIG);
			facade.registerCommand(LoadLoginResourcesCommand.LOAD_LOGIN_RESOURCE_NOTE, LoadLoginResourcesCommand);
			
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			facade.sendNotification(LoadLoginResourcesCommand.LOAD_LOGIN_RESOURCE_NOTE);
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