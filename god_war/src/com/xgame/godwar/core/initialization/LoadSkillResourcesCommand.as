package com.xgame.godwar.core.initialization
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadSkillResourcesCommand extends SimpleCommand
	{
		public static const LOAD_RESOURCES: String  = "LoadSkillResourcesCommand.LoadResources";
		public static const LOAD_LOGIC: String  = "LoadSkillResourcesCommand.LoadLogic";
		
		public function LoadSkillResourcesCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LOAD_RESOURCES:
					facade.removeCommand(LOAD_RESOURCES);
					facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
					facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_skill_ui"));
					ResourceCenter.instance.load("magician_skill_ui", null, onResourceComplete, onProgress, onIOError);
					break;
				case LOAD_LOGIC:
					facade.removeCommand(LOAD_LOGIC);
					facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
					facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_skill_logic"));
					ResourceCenter.instance.load("magician_skill_logic", null, onLogicComplete, onProgress, onIOError);
					break;
			}
		}
		
		private function onResourceComplete(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.sendNotification(LOAD_LOGIC);
		}
		
		private function onLogicComplete(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
			facade.sendNotification(LoadHotkeyConfigCommand.LOAD_HOTKEY_CONFIG_NOTE);
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