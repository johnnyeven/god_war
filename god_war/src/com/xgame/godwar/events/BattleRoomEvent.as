package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class BattleRoomEvent extends Event
	{
		public static const CARD_CONFIG_CLICK: String = "BattleRoomEvent.CardConfigClick";
		public static const READY_CLICK: String = "BattleRoomEvent.ReadyClick";
		
		public var value: Object;
		
		public function BattleRoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}