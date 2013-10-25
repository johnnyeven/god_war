package com.xgame.godwar.core.login.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.ServerListProxy;
	import com.xgame.godwar.core.initialization.LoadServerListCommand;
	import com.xgame.godwar.core.login.views.ServerComponent;
	import com.xgame.godwar.events.LoginEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class ServerMediator extends BaseMediator
	{
		public static const NAME: String = "ServerMediator";
		public static const SHOW_NOTE: String = "ServerMediator.ShowNote";
		public static const HIDE_NOTE: String = "ServerMediator.HideNote";
		public static const DISPOSE_NOTE: String = "ServerMediator.DisposeNote";
		public static const SHOW_SERVER_NOTE: String = "ServerMediator.ShowServerNote";
		
		public function ServerMediator()
		{
			super(NAME, new ServerComponent());
			component.mediator = this;
			component.x = 1028;
			onShow = moveIntoScene;
			
			component.addEventListener(LoginEvent.SERVERLIST_BACK_EVENT, onServerListBackClick);
			
			facade.registerCommand(LoadServerListCommand.LOAD_SERVERLIST_NOTE, LoadServerListCommand);
			facade.registerProxy(new ServerListProxy());
		}
		
		public function get component(): ServerComponent
		{
			return viewComponent as ServerComponent;
		}
		
		private function onServerListBackClick(evt: LoginEvent): void
		{
			facade.sendNotification(LoginBGMediator.CHANGE_NOTE, 1);
			component.hide(function(): void
			{
				dispose();
				facade.registerMediator(new StartMediator());
				facade.sendNotification(StartMediator.SHOW_NOTE);
			});
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_SERVER_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					break;
				case HIDE_NOTE:
					component.hide(dispose);
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
				case SHOW_SERVER_NOTE:
					showServerComponent();
					break;
			}
		}
		
		private function moveIntoScene(_mediator: BaseMediator): void
		{
			TweenLite.to(component, .6, {x: 0, ease: Strong.easeOut, onComplete: onShowCallback});
		}
		
		private function onShowCallback(): void
		{
			sendNotification(LoadServerListCommand.LOAD_SERVERLIST_NOTE);
		}
		
		private function showServerComponent(): void
		{
			var _proxy: ServerListProxy = facade.retrieveProxy(ServerListProxy.NAME) as ServerListProxy;
			
			component.showServerList(_proxy.getData() as Vector.<ServerListParameter>);
		}
	}
}