package com.xgame.godwar.events
{
	import flash.events.Event;
	
	public class BattleGameEvent extends Event
	{
		public static const NAME: String = "BattleGameEvent";
		public static const CHOUPAI_EVENT: String = NAME + ".ChouPaiEvent";
		public static const CHOUPAI_COMPLETE_EVENT: String = NAME + ".ChouPaiCompleteEvent";
		public static const DEPLOY_PHASE_EVENT: String = NAME + ".DeployPhaseEvent";
		public static const FIGHT_EVENT: String = NAME + ".FightEvent";
		public static const ROUND_STANDBY_EVENT: String = NAME + ".RoundStandbyEvent";
		
		public var value: Object;
		
		public function BattleGameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}