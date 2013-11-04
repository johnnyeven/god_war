package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class CreateBattleRoomEvent extends Event
	{
		public static const OK_CLICK: String = "CreateBattleRoomEvent.OkClick";
		public static const CANCEL_CLICK: String = "CreateBattleRoomEvent.CancelClick";
		
		public function CreateBattleRoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}