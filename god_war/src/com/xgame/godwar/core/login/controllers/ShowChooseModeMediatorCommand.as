package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.login.mediators.ChooseModeMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowChooseModeMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowChooseModeMediatorCommand.CreateNote";
		
		public function ShowChooseModeMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(SHOW_NOTE);
			
			var _mediator: ChooseModeMediator = facade.retrieveMediator(ChooseModeMediator.NAME) as ChooseModeMediator;
			if (_mediator != null)
			{
				facade.sendNotification(ChooseModeMediator.SHOW_NOTE);
			}
			else
			{
				ResourceCenter.instance.load("choose_mode_ui", null, onLoadComplete);
			}
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			facade.registerMediator(new ChooseModeMediator());
			
			facade.sendNotification(ChooseModeMediator.SHOW_NOTE);
		}
	}
}