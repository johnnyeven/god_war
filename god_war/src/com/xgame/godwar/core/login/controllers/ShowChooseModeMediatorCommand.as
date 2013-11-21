package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.initialization.LoadSoulCardConfigCommand;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.login.mediators.ChooseModeMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowChooseModeMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowChooseModeMediatorCommand.CreateNote";
		
		public function ShowChooseModeMediatorCommand()
		{
			super();
			facade.registerCommand(LoadSoulCardConfigCommand.LOAD_NOTE, LoadSoulCardConfigCommand);
			facade.sendNotification(LoadSoulCardConfigCommand.LOAD_NOTE);
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(SHOW_NOTE);
			facade.removeCommand(ShowLoginMediatorCommand.SHOW_NOTE);
			facade.removeCommand(ShowRegisterMediatorCommand.SHOW_NOTE);
			
			var _mediator: ChooseModeMediator = facade.retrieveMediator(ChooseModeMediator.NAME) as ChooseModeMediator;
			if (_mediator != null)
			{
				facade.sendNotification(ChooseModeMediator.SHOW_NOTE);
			}
			else
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("choose_mode_ui", null, onLoadComplete, onLoadProgress);
			}
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new ChooseModeMediator());
			facade.sendNotification(ChooseModeMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}