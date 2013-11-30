package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_DeleteGroup;
	import com.xgame.godwar.common.commands.sending.Send_Info_DeleteGroup;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.setting.views.DeleteGroupComponent;
	import com.xgame.godwar.enum.PopupEffect;
	import com.xgame.godwar.events.CardConfigEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class DeleteGroupMediator extends BaseMediator
	{
		public static const NAME:String = "DeleteGroupMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		
		public var currentGroupId: int;
		
		public function DeleteGroupMediator()
		{
			super(NAME, new DeleteGroupComponent());
			component.mediator = this;
			_isPopUp = true;
			mode = true;
			popUpEffect = PopupEffect.CENTER;
			
			component.addEventListener(CardConfigEvent.DELETE_GROUP_OK_CLICK, onBtnOkClick);
			component.addEventListener(CardConfigEvent.DELETE_GROUP_CANCEL_CLICK, onBtnCancelClick);
			
			CommandList.instance.bind(SocketContextConfig.INFO_DELETE_GROUP, Receive_Info_DeleteGroup);
			CommandCenter.instance.add(SocketContextConfig.INFO_DELETE_GROUP, onDeleteGroup);
		}
		
		public function get component(): DeleteGroupComponent
		{
			return viewComponent as DeleteGroupComponent;
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
					currentGroupId = int(notification.getBody());
					show();
					break;
				case HIDE_NOTE:
					remove();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
			}
		}
		
		private function onBtnOkClick(evt: CardConfigEvent): void
		{
			if(CommandCenter.instance.connected && currentGroupId > 0)
			{
				var protocol: Send_Info_DeleteGroup = new Send_Info_DeleteGroup();
				protocol.groupId = currentGroupId;
				
				CommandCenter.instance.send(protocol);
				facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
			}
		}
		
		private function onBtnCancelClick(evt: CardConfigEvent): void
		{
			remove();
		}
		
		private function onDeleteGroup(protocol: Receive_Info_DeleteGroup): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			remove();
			
			facade.sendNotification(CardConfigMediator.REMOVE_CARD_GROUP_NOTE, protocol.groupId);
		}
	}
}