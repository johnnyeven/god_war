package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.hall.controllers.ShowBattleHallMediatorCommand;
	import com.xgame.godwar.core.hall.proxy.HallProxy;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	import com.xgame.godwar.utils.debug.Debug;
	import com.xgame.godwar.utils.debug.Stats;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadInitDataCommand extends SimpleCommand
	{
		public static const LOAD_INIT_DATA_NOTE: String = "LoadInitDataCommand.LoadInitDataNote";
		public static const LOAD_HALL: String = "LoadInitDataCommand.LoadHall";
		
		public function LoadInitDataCommand()
		{
			super();
			facade.registerCommand(ShowBattleHallMediatorCommand.SHOW_NOTE, ShowBattleHallMediatorCommand);
		}
		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LOAD_INIT_DATA_NOTE:
					facade.removeCommand(LOAD_INIT_DATA_NOTE);
					facade.sendNotification(LoadCharacterResourceCommand.LOAD_RESOURCE);
					break;
				case LOAD_HALL:
					facade.removeCommand(LOAD_HALL);
//					facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
//					facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_TITLE_NOTE, LanguageManager.getInstance().lang("load_scene"));
					loadHall();
					loadDebug();
					break;
			}
		}
		
		private function loadDebug(): void
		{
			var _debugLayer: Sprite = new Sprite();
			var _debugStats: Stats = new Stats();
			_debugLayer.addChild(_debugStats);
			GameManager.container.stage.addChild(_debugLayer);
		}
		
		private function loadHall(): void
		{
			var _proxy: HallProxy = facade.retrieveProxy(HallProxy.NAME) as HallProxy;
			var _mode: int = 0;
			if(_proxy != null)
			{
				_mode = _proxy.mode;
			}
			
			if(_mode == 1) //势力战
			{
				
			}
			else if(_mode == 0) //对战
			{
				facade.sendNotification(ShowBattleHallMediatorCommand.SHOW_NOTE);
			}
		}
	}
}