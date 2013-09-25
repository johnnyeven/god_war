package com.xgame.godwar.core.initialization
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadCharacterResourceCommand extends SimpleCommand
	{
		public static const LOAD_RESOURCE: String = "LoadCharacterResourceCommand.LoadResource";
		
		public function LoadCharacterResourceCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_RESOURCE);
			facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_character_ui"));
			ResourceCenter.instance.load("magician_character_1", null, onComplete, onProgress, onIOError);
		}
		
		private function onComplete(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.sendNotification(LoadSkillResourcesCommand.LOAD_RESOURCES);
		}
		
		private function onProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
		
		private function onIOError(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, evt.text);
		}
	}
}