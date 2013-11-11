package com.xgame.godwar.core.login.controllers
{
	import com.xgame.godwar.core.login.mediators.RegisterMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowRegisterMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowRegisterMediatorCommand.ShowNote";
		
		public function ShowRegisterMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new RegisterMediator());
			facade.sendNotification(RegisterMediator.SHOW_NOTE);
		}
	}
}