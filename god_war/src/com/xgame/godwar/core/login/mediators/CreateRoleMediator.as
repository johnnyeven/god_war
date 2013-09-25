package com.xgame.godwar.core.login.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.login.views.CreateRoleComponent;
	import com.xgame.godwar.enum.PopupEffect;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateRoleMediator extends BaseMediator implements IMediator
	{
		public static const NAME: String = "CreateRoleMediator";
		public static const SHOW_NOTE: String = "CreateRoleMediator.ShowNote";
		public static const DISPOSE_NOTE: String = "CreateRoleMediator.DisposeNote";
		public static const SEND_CREATE_ROLE_NOTE: String = "CreateRoleMediator.SendCreateRoleNote";
		
		public function CreateRoleMediator()
		{
			super(NAME, new CreateRoleComponent());
			component.mediator = this;
			_isPopUp = true;
			popUpEffect = PopupEffect.TOP;
		}
		
		public function get component(): CreateRoleComponent
		{
			return viewComponent as CreateRoleComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, DISPOSE_NOTE, SEND_CREATE_ROLE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
				case SEND_CREATE_ROLE_NOTE:
					sendCreateRole(notification.getBody() as String);
					break;
			}
		}
		
		private function sendCreateRole(roleName: String): void
		{
			var _proxy: RequestRoleProxy;
			if(!facade.hasProxy(RequestRoleProxy.NAME))
			{
				_proxy = new RequestRoleProxy();
				facade.registerProxy(_proxy);
			}
			else
			{
				_proxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			}
			if(_proxy != null)
			{
				_proxy.registerAccountRole(roleName);
			}
		}
	}
}