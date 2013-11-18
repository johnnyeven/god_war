package com.xgame.godwar.core.setting.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.setting.mediators.CardConfigMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowCardConfigMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowCardConfigMediatorCommand.ShowNote";
		
		public function ShowCardConfigMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mediator: CardConfigMediator = facade.retrieveMediator(CardConfigMediator.NAME) as CardConfigMediator;
			if(mediator != null)
			{
				facade.sendNotification(CardConfigMediator.SHOW_NOTE);
			}
			else
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("card_config_ui", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new CardConfigMediator());
			facade.sendNotification(CardConfigMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}