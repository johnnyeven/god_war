package com.xgame.godwar.core.room.mediators
{
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.room.views.BattleGuideComponent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleGuideMediator extends BaseMediator
	{
		public static const NAME: String = "BattleGuideMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const CHANGE_CONTENT_NOTE: String = NAME + ".ChangeContentNote";
		
		public function BattleGuideMediator()
		{
			super(NAME, new BattleGuideComponent());
		}
		
		public function get component(): BattleGuideComponent
		{
			return viewComponent as BattleGuideComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, CHANGE_CONTENT_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					component.show(notification.getBody() as Function);
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
				case CHANGE_CONTENT_NOTE:
					component.caption = String(notification.getBody());
					break;
			}
		}
		
		override protected function addComponent(): void
		{
			GameManager.instance.addInfo(component);
		}
		
		override public function remove(): void
		{
			GameManager.instance.removeInfo(component);
		}
		
		override public function dispose(): void
		{
			GameManager.instance.removeInfo(component);
			component.dispose();
			viewComponent = null;
			callDestroyCallback();
		}
		
		public function hide(callback: Function = null): void
		{
			component.hide(callback);
		}
	}
}