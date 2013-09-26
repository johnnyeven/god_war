package com.xgame.godwar.core.login.mediators
{
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.mediators.MainMediator;
	import com.xgame.godwar.core.login.proxy.LoginProxy;
	import com.xgame.godwar.core.login.views.StartComponent;
	import com.xgame.godwar.events.LoginEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class StartMediator extends BaseMediator
	{
		public static const NAME: String = "LoginMediator";
		
		public static const SHOW_NOTE: String = "Show" + NAME;
		public static const DESTROY_NOTE: String = "Destroy" + NAME;
		
		public function StartMediator(viewComponent:Object=null)
		{
			super(NAME, new StartComponent());
			
			facade.registerProxy(new LoginProxy());
			
			component.addEventListener(LoginEvent.START_EVENT, onLoginStart);
			component.addEventListener(LoginEvent.ACCOUNT_EVENT, onLoginAccount);
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, DESTROY_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					break;
				case DESTROY_NOTE:
					dispose();
					break;
			}
		}
		
		private function onLoginStart(evt: LoginEvent): void
		{
//			component.switchDoorStatus(false);
//			component.openDoor(startHandler);
		}
		
		private function onLoginAccount(evt: LoginEvent): void
		{
//			component.switchDoorStatus(false);
//			component.openDoor(accountHandler);
		}
		
		private function startHandler(): void
		{
			var _loginProxy: LoginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			_loginProxy.quickStart();
			dispose();
		}
		
		private function accountHandler(): void
		{
			
		}
		
		public function get component(): StartComponent
		{
			return viewComponent as StartComponent;
		}
		
		override public function show(): void
		{
			super.show();
			component.show();
		}
	}
}