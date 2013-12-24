package com.xgame.godwar.core.general.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TimerComponent extends Component
	{
		private static var tmp: Array = [
			"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
		];
		private static var numericList: Vector.<BitmapData>;
		
		private var singleWidth: int;
		private var singleHeight: int;
		private var timeCount: int;
		private var isDispose: Boolean = false;
		
		public function TimerComponent()
		{
			super(null);
			
			numericList = new Vector.<BitmapData>();
			
			var bd: BitmapData;
			for(var i: int = 0; i<10; i++)
			{
				bd = ResourcePool.instance.getBitmapData("assets.ui.numeric." + tmp[i]);
				numericList.push(bd);
				if(i == 0)
				{
					singleWidth = bd.width;
					singleHeight = bd.height;
				}
			}
		}
		
		private function getTimeResource(time: int): Bitmap
		{
			var length: int = time.toString().length;
			var bd: BitmapData = new BitmapData(singleWidth * length, singleHeight, true, 0);
			var m: int;
			var bdTime: BitmapData;
			var rect: Rectangle = new Rectangle(0, 0, singleWidth, singleHeight);
			var p: Point = new Point();
			for(var i: int = 0; i<length; i++)
			{
				m = time % 10;
				time = time / 10;
				p.x = singleWidth * (length - i - 1);
				
				bdTime = numericList[m];
				bd.copyPixels(bdTime, rect, p);
			}
			
			var b: Bitmap = new Bitmap(bd, "auto", true);
			
			return b;
		}
		
		public function addTimer(time: int): void
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
			addChild(b);
			
			if(timeCount == 0)
			{
				TimerManager.instance.remove(onTimer);
				isDispose = true;
			}
			else
			{
				timeCount--;
			}
			
			TweenLite.to(b, .3, {transformAroundCenter: { scaleX: 1, scaleY: 1, alpha: 1 }, ease: Strong.easeOut, onComplete: function(): void
			{
				TweenLite.to(b, .5, {y: b.y + 200, alpha: 0, ease: Strong.easeIn, onComplete: removeTimeResource, onCompleteParams: [b]});
			}});
		}
		
		private function removeTimeResource(b: Bitmap): void
		{
			removeChild(b);
			b.bitmapData = null;
			b = null;
			TweenLite.killTweensOf(b);
			
			if(isDispose)
			{
				GameManager.instance.removeToolTip(this);
				dispose();
			}
		}
	}
}