package com.xgame.godwar.core.general.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.general.views.TimerComponent;
	import com.xgame.godwar.utils.UIUtils;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TimerMediator extends Mediator implements IMediator
	{
		public static const NAME: String = "TimerMediator";
		public static const ADD_TIMER_NOTE: String = NAME + ".AddTimerNote";
		
		public function TimerMediator()
		{
			super(NAME, null);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ADD_TIMER_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ADD_TIMER_NOTE:
					addTimer(int(notification.getBody()));
					break;
			}
		}
		
		private function addTimer(time: int): void
		{
			var component: TimerComponent = new TimerComponent();
			GameManager.instance.addToolTip(component);
			component.addTimer(time);
		}
	}
}