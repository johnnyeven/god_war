package com.xgame.godwar.core.hall.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.hall.mediators.BattleHallMediator;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	
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
			
			var mediator: BattleHallMediator = facade.retrieveMediator(BattleHallMediator.NAME) as BattleHallMediator;
			if(mediator != null)
			{
				facade.sendNotification(BattleHallMediator.SHOW_NOTE);
			}
			else
			{
				ResourceCenter.instance.load("hall1_ui", null, onResourceLoaded);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.registerMediator(new BattleHallMediator());
			
			facade.sendNotification(BattleHallMediator.SHOW_NOTE);
		}
	}
}