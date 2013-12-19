package com.xgame.godwar.core.room.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.core.room.mediators.BattleGameMediator;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.proxy.BattleRoomProxy;
	import com.xgame.godwar.utils.debug.Debug;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowBattleGameMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowBattleGameMediatorCommand.ShowNote";
		
		public function ShowBattleGameMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var roomProxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
			if(!facade.hasProxy(BattleGameProxy.NAME) && roomProxy != null)
			{
				var proxy: BattleGameProxy = new BattleGameProxy();
				proxy.currentRoomId = roomProxy.currentRoomId;
				facade.registerProxy(proxy);
			}
			else
			{
				CONFIG::DebugMode
				{
					Debug.error(this, "无法获取当前房间ID");
				}
				return;
			}
			try
			{
				facade.registerMediator(new BattleGameMediator());
				facade.sendNotification(BattleGameMediator.SHOW_NOTE);
			}
			catch(err: Error)
			{
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("battle_game_ui", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new BattleGameMediator());
			facade.sendNotification(BattleGameMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}