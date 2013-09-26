package com.xgame.godwar.core.login.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.login.views.LoginBGComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class LoginBGMediator extends BaseMediator
	{
		public static const NAME: String = "LoginBGMediator";
		
		public static const SHOW_NOTE: String = "LoginBGMediator.showNote";
		public static const HIDE_NOTE: String = "LoginBGMediator.hideNote";
		public static const CHANGE_NOTE: String = "LoginBGMediator.changeNote";
		public static const DISPOSE_NOTE: String = "LoginBGMediator.disposeNote";
		
		public function LoginBGMediator()
		{
			super(NAME, new LoginBGComponent());
		}
		
		public function get component(): LoginBGComponent
		{
			return viewComponent as LoginBGComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, CHANGE_NOTE, DISPOSE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					break;
				case HIDE_NOTE:
					hide();
					break;
				case CHANGE_NOTE:
					change();
					break;
				case DISPOSE_NOTE:
					dispose();
			}
		}
		
		override public function show():void
		{
			super.show();
			component.show();
		}
		
		override public function dispose():void
		{
			component.hide(super.dispose);
		}
		
		public function hide(): void
		{
			component.hide();
		}
		
		public function change(): void
		{
			component.change();
		}
	}
}