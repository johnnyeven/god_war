package com.xgame.godwar.core.room.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.general.mediators.TimerMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.room.mediators.BattleRoomMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowBattleRoomMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowBattleRoomMediatorCommand.ShowNote";
		
		public function ShowBattleRoomMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mediator: BattleRoomMediator = facade.retrieveMediator(BattleRoomMediator.NAME) as BattleRoomMediator;
			if(mediator != null)
			{
				facade.sendNotification(BattleRoomMediator.SHOW_NOTE);
			}
			else
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("battle_ui", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new TimerMediator());
			facade.registerMediator(new BattleRoomMediator());
			facade.sendNotification(BattleRoomMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}