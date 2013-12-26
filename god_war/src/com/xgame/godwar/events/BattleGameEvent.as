package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class BattleGameEvent extends Event
	{
		public static const NAME: String = "BattleGameEvent";
		public static const CHOUPAI_EVENT: String = NAME + ".ChouPaiEvent";
		
		public var value: Object;
		
		public function BattleGameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}