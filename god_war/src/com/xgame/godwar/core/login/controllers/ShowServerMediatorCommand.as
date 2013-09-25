package com.xgame.godwar.core.login.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.center.ResourceCenter;
	
	import flash.display.DisplayObject;
	
	import mediators.login.ServerMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowServerMediatorCommand extends SimpleCommand
	{
		public static const CREATE_NOTE: String = "CreateServerMediatorCommand.CreateNote";
		
		public function ShowServerMediatorCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(ShowServerMediatorCommand.CREATE_NOTE);
			
			var _mediator: ServerMediator = facade.retrieveMediator(ServerMediator.NAME) as ServerMediator;
			if (_mediator != null)
			{
				facade.sendNotification(ServerMediator.SHOW_NOTE);
			}
			else
			{
				ResourceCenter.instance.load("server_ui", null, onLoadComplete);
			}
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			facade.registerMediator(new ServerMediator());
			
			facade.sendNotification(ServerMediator.SHOW_NOTE);
		}
	}
}