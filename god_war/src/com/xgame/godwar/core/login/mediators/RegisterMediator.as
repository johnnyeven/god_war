package com.xgame.godwar.core.login.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.login.proxy.LoginProxy;
	import com.xgame.godwar.core.login.views.RegisterComponent;
	import com.xgame.godwar.events.LoginEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class RegisterMediator extends BaseMediator
	{
		public static const NAME: String = "RegisterMediator";
		
		public static const SHOW_NOTE: String = "Show" + NAME;
		public static const DESTROY_NOTE: String = "Destroy" + NAME;
		
		public function RegisterMediator()
		{
			super(NAME, new RegisterComponent());
			
			component.x = 1028;
			component.addEventListener(LoginEvent.REGISTER_CLICK_EVENT, onLoginClick);
			component.addEventListener(LoginEvent.REGISTER_BACK_EVENT, onBackClick);
		}
		
		public function get component(): RegisterComponent
		{
			return viewComponent as RegisterComponent;
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
		
		override public function show():void
		{
			super.show();
			TweenLite.to(component, .5, {x: 0, ease: Strong.easeOut});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, {x: -1028, ease: Strong.easeIn, onComplete: callback});
		}
		
		private function onLoginClick(evt: LoginEvent): void
		{
			hide(function(): void
			{
				var _loginProxy: LoginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
				_loginProxy.register(component.userName, component.userPass);
				
				dispose();
			});
		}
		
		private function onBackClick(evt: LoginEvent): void
		{
			facade.sendNotification(LoginBGMediator.CHANGE_NOTE, 1);
			hide(function(): void
			{
				dispose();
				facade.registerMediator(new StartMediator());
				facade.sendNotification(StartMediator.SHOW_NOTE);
			});
		}
	}
}