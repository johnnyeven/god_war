package com.xgame.godwar.core.login.controllers
{
	import com.xgame.godwar.core.login.mediators.LoginBGMediator;
	import com.xgame.godwar.core.login.mediators.StartMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowStartMediatorCommand extends SimpleCommand
	{
		public static const CREATE_LOGIN_VIEW_NOTE: String = "CreateLoginViewCommand";
		
		public function ShowStartMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(CREATE_LOGIN_VIEW_NOTE);
			
			facade.registerMediator(new LoginBGMediator());
			facade.sendNotification(LoginBGMediator.SHOW_NOTE);
			facade.registerMediator(new StartMediator());
			facade.sendNotification(StartMediator.SHOW_NOTE);
		}
	}
}