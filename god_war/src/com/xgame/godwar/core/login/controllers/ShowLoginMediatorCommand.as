package com.xgame.godwar.core.login.controllers
{
	import com.xgame.godwar.core.login.mediators.LoginMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowLoginMediatorCommand extends SimpleCommand
	{
		public static const SHOW_NOTE: String = "ShowLoginMediatorCommand.ShowNote";
		
		public function ShowLoginMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new LoginMediator());
			facade.sendNotification(LoginMediator.SHOW_NOTE);
		}
	}
}