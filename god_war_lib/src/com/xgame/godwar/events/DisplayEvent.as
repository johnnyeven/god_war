package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class DisplayEvent extends Event
	{
		public static const NAME: String = "DisplayEvent";
		public static const MOVIE_PLAY_COMPLETE: String = NAME + ".MoviePlayComplete";
		
		public function DisplayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}