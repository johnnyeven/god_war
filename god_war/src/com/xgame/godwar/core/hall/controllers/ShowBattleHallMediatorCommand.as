package com.xgame.godwar.core.hall.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.hall.mediators.BattleHallMediator;
	import com.xgame.godwar.core.hall.mediators.CreateBattleRoomMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.setting.controllers.ShowCardConfigMediatorCommand;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowBattleHallMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowBattleHallMediatorCommand.ShowNote";
		
		public function ShowBattleHallMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(SHOW_NOTE);
			facade.registerCommand(ShowCreateBattleHallMediatorCommand.SHOW_NOTE, ShowCreateBattleHallMediatorCommand);
			facade.registerCommand(ShowCardConfigMediatorCommand.SHOW_NOTE, ShowCardConfigMediatorCommand);
			
			var mediator: BattleHallMediator = facade.retrieveMediator(BattleHallMediator.NAME) as BattleHallMediator;
			if(mediator != null)
			{
				facade.sendNotification(BattleHallMediator.SHOW_NOTE);
			}
			else
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("hall1_ui_batch", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new BattleHallMediator());
			facade.registerMediator(new CreateBattleRoomMediator());
			facade.sendNotification(BattleHallMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}