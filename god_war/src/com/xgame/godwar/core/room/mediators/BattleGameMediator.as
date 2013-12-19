package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleGameMediator extends BaseMediator
	{
		public static const NAME: String = "BattleGameMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const SHOW_ROOM_DATA_NOTE: String = NAME + ".ShowRoomDataNote";
		
		public function BattleGameMediator()
		{
			super(NAME, new BattleGameComponent());
			
			component.mediator = this;
		}
		
		public function get component(): BattleGameComponent
		{
			return viewComponent as BattleGameComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_DATA_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					requestEnterRoom();
					break;
				case HIDE_NOTE:
					hide(function(): void
					{
						remove();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
					break;
				case DISPOSE_NOTE:
					hide(function(): void
					{
						dispose();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
				case SHOW_ROOM_DATA_NOTE:
					showRoomData(notification.getBody() as Receive_BattleRoom_InitRoomDataLogicServer);
					break;
			}
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, { alpha: 0, ease: Strong.easeIn, onComplete: callback });
		}
		
		private function requestEnterRoom(): void
		{
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			proxy.requestEnterRoom();
		}
		
		private function showRoomData(protocol: Receive_BattleRoom_InitRoomDataLogicServer): void
		{
			trace(protocol);
		}
	}
}