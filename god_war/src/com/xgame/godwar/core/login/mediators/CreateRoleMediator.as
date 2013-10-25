package com.xgame.godwar.core.login.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.login.views.CreateRoleComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.LoginEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateRoleMediator extends BaseMediator implements IMediator
	{
		public static const NAME: String = "CreateRoleMediator";
		public static const SHOW_NOTE: String = "CreateRoleMediator.ShowNote";
		public static const HIDE_NOTE: String = "CreateRoleMediator.HideNote";
		public static const DISPOSE_NOTE: String = "CreateRoleMediator.DisposeNote";
		public static const SEND_CREATE_ROLE_NOTE: String = "CreateRoleMediator.SendCreateRoleNote";
		
		public function CreateRoleMediator()
		{
			super(NAME, new CreateRoleComponent());
			component.mediator = this;
			
			component.addEventListener(LoginEvent.CREATEROLE_BACK_EVENT, onCreateRoleBackClick);
		}
		
		public function get component(): CreateRoleComponent
		{
			return viewComponent as CreateRoleComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SEND_CREATE_ROLE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					component.show();
					break;
				case HIDE_NOTE:
					dispose();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
				case SEND_CREATE_ROLE_NOTE:
					sendCreateRole(notification.getBody() as String);
					break;
			}
		}
		
		private function onCreateRoleBackClick(evt: LoginEvent): void
		{
			component.hide(function(): void
			{
				dispose();
				facade.registerMediator(new ServerMediator());
				facade.sendNotification(ServerMediator.SHOW_NOTE);
			});
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