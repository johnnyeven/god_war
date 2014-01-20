package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class CardEvent extends Event
	{
		public static const NAME: String = "CardEvent";
		public static const FIGHT_CLICK: String = NAME + ".FightClick";
		
		public var value: Object;
		
		public function CardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}