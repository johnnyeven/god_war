package com.xgame.godwar.core.hall.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.hall.controllers.ShowCreateBattleHallMediatorCommand;
	import com.xgame.godwar.core.hall.proxy.HallProxy;
	import com.xgame.godwar.core.hall.views.BattleHallComponent;
	import com.xgame.godwar.core.hall.views.BattleRoomListItemComponent;
	import com.xgame.godwar.core.room.controllers.ShowBattleRoomMediatorCommand;
	import com.xgame.godwar.core.room.proxy.BattleRoomProxy;
	import com.xgame.godwar.core.setting.controllers.ShowCardConfigMediatorCommand;
	import com.xgame.godwar.events.BattleHallEvent;
	import com.xgame.godwar.utils.manager.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleHallMediator extends BaseMediator implements IMediator
	{
		public static const NAME: String = "BattleHallMediator";
		public static const SHOW_NOTE: String = "BattleHallMediator.ShowNote";
		public static const HIDE_NOTE: String = "BattleHallMediator.HideNote";
		public static const DISPOSE_NOTE: String = "BattleHallMediator.DisposeNote";
		public static const SHOW_ROOM_LIST_NOTE: String = "BattleHallMediator.ShowRoomListNote";
		public static const ADD_ROOM_NOTE: String = "BattleHallMediator.AddRoomNote";
		
		public function BattleHallMediator()
		{
			super(NAME, new BattleHallComponent());
			component.mediator = this;
			
			component.addEventListener(BattleHallEvent.CREATE_ROOM_CLICK, showCreateRoom);
			component.addEventListener(BattleHallEvent.CARD_CONFIG_CLICK, showCardConfig);
			component.addEventListener(BattleHallEvent.ROOM_CLICK, onRoomClick);
			
			if(!facade.hasProxy(BattleRoomProxy.NAME))
			{
				facade.registerProxy(new BattleRoomProxy());
			}
			if(!facade.hasCommand(ShowBattleRoomMediatorCommand.SHOW_NOTE))
			{
				facade.registerCommand(ShowBattleRoomMediatorCommand.SHOW_NOTE, ShowBattleRoomMediatorCommand);
			}
		}
		
		public function get component(): BattleHallComponent
		{
			return viewComponent as BattleHallComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, SHOW_ROOM_LIST_NOTE, ADD_ROOM_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
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
				case SHOW_ROOM_LIST_NOTE:
					onShowRoomList(notification.getBody() as Vector.<RoomListItemParameter>);
					break;
				case ADD_ROOM_NOTE:
					onAddRoom(notification.getBody() as RoomListItemParameter);
					break;
			}
		}
		
		override public function show():void
		{
			super.show();
			component.y = -600;
			
			TweenLite.to(component, .5, { y: 0, ease: Strong.easeOut, onComplete: showRoomList });
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, { y: -600, ease: Strong.easeIn, onComplete: callback });
		}
		
		private function showRoomList(): void
		{
			var _proxy: HallProxy = facade.retrieveProxy(HallProxy.NAME) as HallProxy;
			if(_proxy != null)
			{
				_proxy.requestRoomList();
			}
		}
		
		private function onShowRoomList(list: Vector.<RoomListItemParameter>): void
		{
			component.addRooms(list);
		}
		
		private function onAddRoom(value: RoomListItemParameter): void
		{
			var item: BattleRoomListItemComponent = new BattleRoomListItemComponent();
			item.info = value;
			component.addRoom(item);
		}
		
		private function showCreateRoom(evt: BattleHallEvent): void
		{
			facade.sendNotification(ShowCreateBattleHallMediatorCommand.SHOW_NOTE, ShowCreateBattleHallMediatorCommand);
		}
		
		private function showCardConfig(evt: BattleHallEvent): void
		{
			facade.sendNotification(ShowCardConfigMediatorCommand.SHOW_NOTE, ShowCardConfigMediatorCommand);
		}
		
		private function onRoomClick(evt: BattleHallEvent): void
		{
			var item: BattleRoomListItemComponent = evt.param as BattleRoomListItemComponent;
			
			var proxy: BattleRoomProxy = facade.retrieveProxy(BattleRoomProxy.NAME) as BattleRoomProxy;
			proxy.currentRoomId = item.info.id;
			
			facade.sendNotification(DISPOSE_NOTE, function(): void
			{
				facade.sendNotification(ShowBattleRoomMediatorCommand.SHOW_NOTE);
			});
		}
	}
}