package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class BattleHallEvent extends Event
	{
		public static const CREATE_ROOM_CLICK: String = "BattleHallEvent.CreateRoomClick";
		
		public function BattleHallEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}