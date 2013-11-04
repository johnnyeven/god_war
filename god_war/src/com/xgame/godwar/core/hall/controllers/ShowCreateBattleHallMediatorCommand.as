package com.xgame.godwar.core.hall.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.hall.mediators.CreateBattleRoomMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowCreateBattleHallMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowCreateBattleHallMediatorCommand.ShowNote";
		
		public function ShowCreateBattleHallMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mediator: CreateBattleRoomMediator = facade.retrieveMediator(CreateBattleRoomMediator.NAME) as CreateBattleRoomMediator;
			if(mediator != null)
			{
				facade.sendNotification(CreateBattleRoomMediator.SHOW_NOTE);
			}
			else
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("create_battle_room_ui", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new CreateBattleRoomMediator());
			facade.sendNotification(CreateBattleRoomMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}