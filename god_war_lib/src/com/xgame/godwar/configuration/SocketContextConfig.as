package com.xgame.godwar.configuration
{
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * ...
	 * @author john
	 */
	public final class SocketContextConfig 
	{
		public static var login_ip: String = 'johnnyeven.3322.org';
		public static var login_port: int = 9040;
		public static var server_ip: String = '';
		public static var server_port: int = 0;
		public static var auth_key: String;
		
		public static const CONTROLLER_HALL: int = 5;
		public static const CONTROLLER_BATTLE: int = 3;
		public static const CONTROLLER_MSG: int = 2;
		public static const CONTROLLER_INFO: int = 0
		//INFO
		public static const ACTION_LOGIN: int = 0;
		public static const ACTION_LOGOUT: int = 1;
		public static const ACTION_QUICK_START: int = 2;
		public static const ACTION_REQUEST_CHARACTER: int = 4;
		public static const ACTION_REGISTER_CHARACTER: int = 5;
		public static const ACTION_BIND_SESSION: int = 7;
		//HALL
		public static const ACTION_REQUEST_ROOM: int = 0;
		public static const ACTION_SHOW_ROOMLIST: int = 1;
		public static const ACTION_ROOM_CREATED: int = 2;
		public static const ACTION_REQUEST_ENTER_ROOM: int = 3;
		public static const ACTION_PLAYER_ENTER_ROOM: int = 4;
		public static const ACTION_PLAYER_SELETED_HERO: int = 5;
		
		public static const TYPE_INT: int = 0;
		public static const TYPE_LONG: int = 1;
		public static const TYPE_STRING: int = 2;
		public static const TYPE_FLOAT: int = 3;
		public static const TYPE_BOOL: int = 4;
		public static const TYPE_DOUBLE: int = 5;
		
		public static const ACK_CONFIRM: int = 1;
		public static const ACK_ERROR: int = 0;
		public static const ORDER_CONFIRM: int = 2;
		//INFO
		public static const QUICK_START: int = ACTION_QUICK_START << 8 | CONTROLLER_INFO;
		public static const REQUEST_ACCOUNT_ROLE: int = ACTION_REQUEST_CHARACTER << 8 | CONTROLLER_INFO;
		public static const REGISTER_ACCOUNT_ROLE: int = ACTION_REGISTER_CHARACTER << 8 | CONTROLLER_INFO;
		public static const INFO_BIND_SESSION: int = ACTION_BIND_SESSION << 8 | CONTROLLER_INFO;
		//HALL
		public static const HALL_REQUEST_ROOM: int = ACTION_REQUEST_ROOM << 8 | CONTROLLER_HALL;
		public static const HALL_SHOW_ROOM_LIST: int = ACTION_SHOW_ROOMLIST << 8 | CONTROLLER_HALL;
		public static const HALL_ROOM_CREATED: int = ACTION_ROOM_CREATED << 8 | CONTROLLER_HALL;
		public static const HALL_REQUEST_ENTER_ROOM: int = ACTION_REQUEST_ENTER_ROOM << 8 | CONTROLLER_HALL;
		public static const HALL_PLAYER_ENTER_ROOM: int = ACTION_PLAYER_ENTER_ROOM << 8 | CONTROLLER_HALL;
		public static const HALL_PLAYER_SELECTED_HERO: int = ACTION_PLAYER_SELETED_HERO << 8 | CONTROLLER_HALL;
		
		public function SocketContextConfig() 
		{
			throw new IllegalOperationError("Config类不允许实例化");
		}
		
	}

}