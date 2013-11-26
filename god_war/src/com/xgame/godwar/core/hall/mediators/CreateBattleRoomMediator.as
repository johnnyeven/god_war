package com.xgame.godwar.core.hall.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestRoom;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestRoom;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.hall.views.CreateBattleRoomComponent;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CreateBattleRoomEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateBattleRoomMediator extends BaseMediator implements IMediator
	{
		public static const NAME: String = "CreateBattleRoomMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		
		public function CreateBattleRoomMediator()
		{
			super(NAME, new CreateBattleRoomComponent());
			component.mediator = this;
			_isPopUp = true;
			mode = true;
			popUpEffect = PopupEffect.CENTER;
			
			component.addEventListener(CreateBattleRoomEvent.OK_CLICK, onBtnOkClick);
			component.addEventListener(CreateBattleRoomEvent.CANCEL_CLICK, onBtnCancelClick);
			
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ROOM, Receive_Hall_RequestRoom);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ROOM, onRoomCreated);
		}
		
		public function get component(): CreateBattleRoomComponent
		{
			return viewComponent as CreateBattleRoomComponent;
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
					break;
				case HIDE_NOTE:
					dispose();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
			}
		}
		
		private function onBtnOkClick(evt: CreateBattleRoomEvent): void
		{
			if(CommandCenter.instance.connected)
			{
				if(component.count > 0)
				{
					var protocol: Send_Hall_RequestRoom = new Send_Hall_RequestRoom();
					protocol.roomType = 0;
					protocol.peopleLimit = component.count;
					protocol.title = component.title;
					
					CommandCenter.instance.send(protocol);
					facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				}
			}
		}
		
		private function onBtnCancelClick(evt: CreateBattleRoomEvent): void
		{
			remove();
		}
		
		private function onRoomCreated(protocol: Receive_Hall_RequestRoom): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			trace(protocol.roomId);
		}
	}
}