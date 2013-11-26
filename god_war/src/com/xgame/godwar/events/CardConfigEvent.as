package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class CardConfigEvent extends Event
	{
		public static const BACK_CLICK: String = "CardConfigEvent.BackClick";
		public static const GROUP_CLICK: String = "CardConfigEvent.GroupClick";
		
		public var value: Object;
		
		public function CardConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}