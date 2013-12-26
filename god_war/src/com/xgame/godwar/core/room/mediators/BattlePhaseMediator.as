package com.xgame.godwar.core.room.mediators
{
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.room.views.BattlePhaseComponent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class BattlePhaseMediator extends Mediator implements IMediator
	{
		public static const NAME: String = "BattlePhaseMediator";
		public static const ADD_PHASE_NOTE: String = NAME + ".AddPhaseNote";
		
		public function BattlePhaseMediator()
		{
			super(NAME, null);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ADD_PHASE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ADD_PHASE_NOTE:
					addPhase(int(notification.getBody()));
					break;
			}
		}
		
		private function addPhase(phase: int): void
		{
			var component: BattlePhaseComponent = new BattlePhaseComponent();
			GameManager.instance.addView(component);
			component.showPhase(phase);
		}
	}
}