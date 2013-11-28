package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.setting.views.CreateGroupComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CardConfigEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateGroupMediator extends BaseMediator
	{
		public static const NAME:String = "CreateGroupMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		
		public function CreateGroupMediator()
		{
			super(NAME, new CreateGroupComponent());
			component.mediator = this;
			_isPopUp = true;
			mode = true;
			popUpEffect = PopupEffect.CENTER;
			
			component.addEventListener(CardConfigEvent.CREATE_GROUP_OK_CLICK, onBtnOkClick);
			component.addEventListener(CardConfigEvent.CREATE_GROUP_CANCEL_CLICK, onBtnCancelClick);
		}
		
		public function get component(): CreateGroupComponent
		{
			return viewComponent as CreateGroupComponent;
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
		
		private function onBtnOkClick(evt: CardConfigEvent): void
		{
			
		}
		
		private function onBtnCancelClick(evt: CardConfigEvent): void
		{
			
		}
	}
}