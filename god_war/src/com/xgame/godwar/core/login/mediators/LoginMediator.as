package com.xgame.godwar.core.login.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.login.views.LoginComponent;
	
	public class LoginMediator extends BaseMediator
	{
		public static const NAME: String = "LoginMediator";
		
		public function LoginMediator()
		{
			super(NAME, new LoginComponent());
		}
		
		public function get component(): LoginComponent
		{
			return viewComponent as LoginComponent;
		}
	}
}