package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class CardConfigEvent extends Event
	{
		public static const BACK_CLICK: String = "CardConfigEvent.BackClick";
		
		public function CardConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}