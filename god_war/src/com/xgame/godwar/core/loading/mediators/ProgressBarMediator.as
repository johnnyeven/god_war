package com.xgame.godwar.core.loading.mediators
{
	import com.xgame.godwar.core.general.mediators.MainMediator;
	import com.xgame.godwar.core.loading.views.LoaderProgressBarComponent;
	import com.xgame.godwar.utils.UIUtils;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ProgressBarMediator extends Mediator implements IMediator
	{
		public static const NAME: String = "ProgressBarMediator";
		
		public static const SHOW_PROGRESSBAR_NOTE: String = "ProgressBarMediator.ShowProgressBarNote";
		public static const HIDE_PROGRESSBAR_NOTE: String = "ProgressBarMediator.HideProgressBarNote";
		public static const SET_PROGRESSBAR_TITLE_NOTE: String = "ProgressBarMediator.SetProgressBarTitleNote";
		public static const SET_PROGRESSBAR_PERCENT_NOTE: String = "ProgressBarMediator.SetProgressBarPercentNote";
		public static const SHOW_RANDOM_BG: String = "ProgressBarMediator.ShowRandomBgNote";
		public static const HIDE_RANDOM_BG: String = "ProgressBarMediator.HideRandomBgNote";
		
		public function ProgressBarMediator()
		{
			super(NAME, new LoaderProgressBarComponent());
		}
		
		private function get component(): LoaderProgressBarComponent
		{
			return viewComponent as LoaderProgressBarComponent;
		}
		
		private function get main(): MainMediator
		{
			return facade.retrieveMediator(MainMediator.NAME) as MainMediator;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_PROGRESSBAR_NOTE, HIDE_PROGRESSBAR_NOTE,
				SET_PROGRESSBAR_TITLE_NOTE, SET_PROGRESSBAR_PERCENT_NOTE,
				SHOW_RANDOM_BG, HIDE_RANDOM_BG];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_PROGRESSBAR_NOTE:
					showProgressBar();
					break;
				case HIDE_PROGRESSBAR_NOTE:
					hideProgressBar();
					break;
				case SET_PROGRESSBAR_TITLE_NOTE:
					setProgressBarTitle(notification.getBody() as String);
					break;
				case SET_PROGRESSBAR_PERCENT_NOTE:
					setProgressBarPercent(notification.getBody() as Number);
					break;
//				case SHOW_RANDOM_BG:
//					showRandomBg();
//					break;
//				case HIDE_RANDOM_BG:
//					hideRandomBg();
//					break;
			}
		}
		
		private function showProgressBar(): void
		{
			if(!main.contains(component))
			{
				main.addChild(component);
				UIUtils.center(component);
				setZero();
			}
		}
		
		private function hideProgressBar(): void
		{
			if(main.contains(component))
			{
				main.removeChild(component);
			}
		}
		
		private function setProgressBarTitle(value: String): void
		{
			component.title = value;
		}
		
		private function setProgressBarPercent(value: Number): void
		{
			component.percentage = value;
		}
		
		private function setZero(): void
		{
			component.percentage = 0;
		}
	}
}