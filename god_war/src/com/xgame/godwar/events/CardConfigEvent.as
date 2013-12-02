package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class CardConfigEvent extends Event
	{
		public static const SAVE_CLICK: String = "CardConfigEvent.SaveClick";
		public static const BACK_CLICK: String = "CardConfigEvent.BackClick";
		public static const GROUP_CLICK: String = "CardConfigEvent.GroupClick";
		public static const CREATE_GROUP_CLICK: String = "CardConfigEvent.CreateGroupClick";
		public static const DELETE_GROUP_CLICK: String = "CardConfigEvent.DeleteGroupClick";
		public static const CREATE_GROUP_OK_CLICK: String = "CardConfigEvent.CreateGroupOkClick";
		public static const CREATE_GROUP_CANCEL_CLICK: String = "CardConfigEvent.CreateGroupCancelClick";
		public static const DELETE_GROUP_OK_CLICK: String = "CardConfigEvent.DeleteGroupOkClick";
		public static const DELETE_GROUP_CANCEL_CLICK: String = "CardConfigEvent.DeleteGroupCancelClick";
		
		public var value: Object;
		
		public function CardConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}