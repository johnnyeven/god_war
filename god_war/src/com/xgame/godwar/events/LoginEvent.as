package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const START_EVENT: String = "LoginEvent.startEvent";
		public static const ACCOUNT_EVENT: String = "LoginEvent.accountEvent";
		public static const REGISTER_EVENT: String = "LoginEvent.registerEvent";
		public static const LOGIN_CLICK_EVENT: String = "LoginEvent.loginClickEvent";
		public static const LOGIN_BACK_EVENT: String = "LoginEvent.loginBackEvent";
		public static const REGISTER_CLICK_EVENT: String = "LoginEvent.registerClickEvent";
		public static const REGISTER_BACK_EVENT: String = "LoginEvent.registerBackEvent";
		public static const SERVERLIST_BACK_EVENT: String = "LoginEvent.serverlistBackEvent";
		public static const CREATEROLE_BACK_EVENT: String = "LoginEvent.createRoleBackEvent";
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}