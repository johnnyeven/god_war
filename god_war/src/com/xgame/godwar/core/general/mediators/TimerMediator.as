package com.xgame.godwar.core.general.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
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
		private static var tmp: Array = [
			"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
		];
		private static var numericList: Vector.<BitmapData>;
		
		public static const NAME: String = "TimerMediator";
		public static const ADD_TIMER_NOTE: String = NAME + ".AddTimerNote";
		
		private var width: int;
		private var height: int;
		private var timeCount: int;
		
		public function TimerMediator()
		{
			super(NAME, null);
			
			numericList = new Vector.<BitmapData>();
			
			var bd: BitmapData;
			for(var i: int = 0; i<10; i++)
			{
				bd = ResourcePool.instance.getBitmapData("assets.ui.numeric." + tmp[i]);
				numericList.push(bd);
				if(i == 0)
				{
					width = bd.width;
					height = bd.height;
				}
			}
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
		
		private function getTimeResource(time: int): Bitmap
		{
			var length: int = time.toString().length;
			var bd: BitmapData = new BitmapData(width * length, height, true, 0);
			var m: int;
			var bdTime: BitmapData;
			var rect: Rectangle = new Rectangle(0, 0, width, height);
			var p: Point = new Point();
			for(var i: int = 0; i<length; i++)
			{
				m = time % 10;
				time = time / 10;
				p.x = width * (length - i - 1);
				
				bdTime = numericList[m];
				bd.copyPixels(bdTime, rect, p);
			}
			
			var b: Bitmap = new Bitmap(bd, "auto", true);
			
			return b;
		}
		
		private function addTimer(time: int): void
		{
			timeCount = time;
			onTimer();
			TimerManager.instance.add(1000, onTimer);
		}
		
		private function onTimer(): void
		{
			var b: Bitmap = getTimeResource(timeCount);
			b.scaleX = 1.5;
			b.scaleY = 1.5;
			b.alpha = 0;
			UIUtils.center(b);
			GameManager.instance.addToolTip(b);
			TweenLite.to(b, .3, {transformAroundCenter: { scaleX: 1, scaleY: 1, alpha: 1 }, ease: Strong.easeOut, onComplete: function(): void
			{
				TweenLite.to(b, .5, {y: b.y + 200, alpha: 0, ease: Strong.easeIn, onComplete: removeTimeResource, onCompleteParams: [b]});
			}});
			
			
			if(timeCount == 0)
			{
				TimerManager.instance.remove(onTimer);
			}
			else
			{
				timeCount--;
			}
		}
		
		private function removeTimeResource(b: Bitmap): void
		{
			GameManager.instance.removeToolTip(b);
			b.bitmapData = null;
			b = null;
		}
	}
}