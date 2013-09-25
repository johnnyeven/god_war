package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.center.HotkeyCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.scene.Scene;
	import com.xgame.godwar.utils.debug.Debug;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartGameCommand extends SimpleCommand
	{
		public static const START_GAME_NOTE: String = "StartGameCommand.StartGameNote";
		private var scene: Scene;

		public function StartGameCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			scene = notification.getBody() as Scene;
			if(scene != null)
			{
				facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
//				createPlayer();
//				TimerManager.instance.add(33, render);
				HotkeyCenter.GlobalEnabled = true;
			}
		}
	}
}