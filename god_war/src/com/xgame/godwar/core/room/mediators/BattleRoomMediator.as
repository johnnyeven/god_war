package com.xgame.godwar.core.room.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.room.proxy.BattleRoomProxy;
	import com.xgame.godwar.core.room.views.BattleRoomComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleRoomMediator extends BaseMediator
	{
		public static const NAME: String = "BattleRoomMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		
		public function BattleRoomMediator()
		{
			super(NAME, new BattleRoomComponent());
		}
		
		public function get component(): BattleRoomComponent
		{
			return viewComponent as BattleRoomComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					component.show(requestEnterRoom);
					break;
				case HIDE_NOTE:
					remove();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
			}
		}
		
		private function requestEnterRoom(): void
		{
			var proxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
			
			proxy.requestEnterRoom();
		}
	}
}