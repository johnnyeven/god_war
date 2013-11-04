package com.xgame.godwar.core.hall.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.hall.views.CreateBattleRoomComponent;
	import com.xgame.godwar.enum.PopupEffect;
	
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
	}
}