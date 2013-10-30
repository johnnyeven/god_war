package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
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
				facade.sendNotification(ProgressBarMediator.SHOW_PROGRESSBAR_NOTE);
				ResourceCenter.instance.load("create_role_ui", null, onResourceLoaded, onLoadProgress);
			}
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			facade.sendNotification(ProgressBarMediator.HIDE_PROGRESSBAR_NOTE);
			
			facade.registerMediator(new CreateRoleMediator());
			facade.sendNotification(CreateRoleMediator.SHOW_NOTE);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			facade.sendNotification(ProgressBarMediator.SET_PROGRESSBAR_PERCENT_NOTE, loader.progress);
		}
	}
}