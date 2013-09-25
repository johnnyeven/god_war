package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowCreateRoleMediatorCommand extends SimpleCommand
	{
		public static const SHOW_CREATE_ROLE_NOTE: String = "ShowCreateRoleMediatorCommand.ShowCreateRoleNote";
		
		public function ShowCreateRoleMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(ShowCreateRoleMediatorCommand.SHOW_CREATE_ROLE_NOTE);
			
			var mediator: CreateRoleMediator = facade.retrieveMediator(CreateRoleMediator.NAME) as CreateRoleMediator;
			if(mediator != null)
			{
				facade.sendNotification(CreateRoleMediator.SHOW_NOTE);
			}
			else
			{
				ResourceCenter.instance.load("create_role_ui", null, onResourceLoaded);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.registerMediator(new CreateRoleMediator());
			
			facade.sendNotification(CreateRoleMediator.SHOW_NOTE);
		}
	}
}