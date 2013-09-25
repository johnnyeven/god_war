package com.xgame.godwar.core.loading.mediators
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.general.mediators.MainMediator;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LoadingIconMediator extends Mediator implements IMediator
	{
		public static const NAME: String = "LoadingIconMediator";
		
		public static const LOADING_SHOW_NOTE: String = "loading_show_note";
		public static const LOADING_HIDE_NOTE: String = "loading_hide_note";
		public static const LOADING_SET_TITLE_NOTE: String = "loading_set_title_note";
		
		private var title: TextField;
		
		public function LoadingIconMediator()
		{
			super(NAME, ResourcePool.instance.getDisplayObject("assets.ui.LoadingIconSkin"));
			title = component.getChildByName("title") as TextField;
		}
		
		public function get component(): MovieClip
		{
			return viewComponent as MovieClip;
		}
		
		override public function listNotificationInterests(): Array
		{
			return [LOADING_SHOW_NOTE, LOADING_HIDE_NOTE, LOADING_SET_TITLE_NOTE];
		}
		
		override public function handleNotification(notification:INotification): void
		{
			switch(notification.getName())
			{
				case LOADING_SHOW_NOTE:
					showLoading();
					break;
				case LOADING_HIDE_NOTE:
					hideLoading();
					break;
				case LOADING_SET_TITLE_NOTE:
					setTitle(String(notification.getBody()));
			}
		}
		
		private function showLoading(): void
		{
			var main: MainMediator = (facade.retrieveMediator(MainMediator.NAME)) as MainMediator;
			component.alpha = 0;
			UIUtils.center(component);
			if(!main.contains(component))
			{
				main.addChild(component);
			}
			TweenLite.to(component, .5, {
				alpha: 1
			});
		}
		
		private function hideLoading(): void
		{
			var main: MainMediator = (facade.retrieveMediator(MainMediator.NAME)) as MainMediator;
			component.alpha = 1;
			TweenLite.to(component, .5, {
				alpha: 0,
				onComplete: function(): void {
					if(main.contains(component))
					{
						main.removeChild(component);
					}
				}
			});
		}
		
		private function setTitle(_title: String): void
		{
			if(title != null)
			{
				if(!StringUtils.empty(_title))
				{
					title.text = _title;
				}
				else
				{
					title.text = "";
				}
			}
		}
	}
}