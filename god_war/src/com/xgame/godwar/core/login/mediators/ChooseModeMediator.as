package com.xgame.godwar.core.login.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.hall.proxy.HallProxy;
	import com.xgame.godwar.core.initialization.LoadInitDataCommand;
	import com.xgame.godwar.core.login.views.ChooseModeComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseModeMediator extends BaseMediator
	{
		public static const NAME: String = "ChooseModeMediator";
		public static const SHOW_NOTE: String = "ChooseModeMediator.showNote";
		public static const HIDE_NOTE: String = "ChooseModeMediator.hideNote";
		public static const ENTER_NOTE: String = "ChooseModeMediator.EnterNote";
		public static const DISPOSE_NOTE: String = "ChooseModeMediator.disposeNote";
		
		public function ChooseModeMediator()
		{
			super(NAME, new ChooseModeComponent());
			
			onShow = moveIntoScene;
			component.x = 1028;
			
			facade.registerCommand(LoadInitDataCommand.LOAD_HALL, LoadInitDataCommand);
			
			facade.registerProxy(new HallProxy());
		}
		
		public function get component(): ChooseModeComponent
		{
			return viewComponent as ChooseModeComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, ENTER_NOTE, DISPOSE_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					break;
				case HIDE_NOTE:
					component.hide(notification.getBody() as Function);
					break;
				case ENTER_NOTE:
					var proxy: HallProxy = facade.retrieveProxy(HallProxy.NAME) as HallProxy;
					proxy.mode = int(notification.getBody());
					component.hide(function(): void
					{
						dispose();
						facade.sendNotification(LoadInitDataCommand.LOAD_HALL);
					});
					break;
				case DISPOSE_NOTE:
					dispose();
					break;
			}
		}
		
		private function moveIntoScene(_mediator: BaseMediator): void
		{
			TweenLite.to(component, .6, {x: 0, ease: Strong.easeOut});
		}
	}
}