package com.xgame.godwar.core.setting.mediators
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_CreateGroup;
	import com.xgame.godwar.common.commands.sending.Send_Info_CreateGroup;
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
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
			
			CommandList.instance.bind(SocketContextConfig.INFO_CREATE_GROUP, Receive_Info_CreateGroup);
			CommandCenter.instance.add(SocketContextConfig.INFO_CREATE_GROUP, onCreateGroup);
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
					remove();
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
			}
		}
		
		private function onBtnOkClick(evt: CardConfigEvent): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_Info_CreateGroup = new Send_Info_CreateGroup();
				protocol.groupName = component.groupName;
				
				CommandCenter.instance.send(protocol);
				facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
			}
		}
		
		private function onBtnCancelClick(evt: CardConfigEvent): void
		{
			remove();
		}
		
		private function onCreateGroup(protocol: Receive_Info_CreateGroup): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			remove();
			
			var parameter:CardGroupParameter = new CardGroupParameter();
			parameter.groupId = protocol.groupId;
			parameter.groupName = protocol.groupName;
			parameter.cardListReady = true;
			
			facade.sendNotification(CardConfigMediator.ADD_CARD_GROUP_NOTE, parameter);
		}
	}
}