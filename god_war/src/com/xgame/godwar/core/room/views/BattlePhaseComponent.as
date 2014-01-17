package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	public class BattlePhaseComponent extends Component
	{
		private static const arr: Array = ["Deploy", "RoundStart", "RoundStandby", "RoundAction", "RoundDiscard", "RoundEnd", "Dieing"];
		
		private var bd: BitmapData;
		private var bitmap: Bitmap;
		private var _phase: int;
		
		public function BattlePhaseComponent()
		{
			super(null);
			
			bitmap = new Bitmap(null);
			addChild(bitmap);
		}
		
		public function showPhase(phase: int): void
		{
			phase = Math.max(0, phase);
			phase = Math.min(6, phase);
			_phase = phase;
			
			bd = ResourcePool.instance.getBitmapData("assets.ui.phase." + arr[phase]);
			if(bd != null)
			{
				bitmap.bitmapData = bd;
				UIUtils.center(bitmap);
				bitmap.y -= 200;
				bitmap.alpha = 0;
				TweenLite.to(bitmap, .5, {y: bitmap.y + 50, alpha: 1, ease: Strong.easeOut, onComplete: function(): void
				{
					TweenLite.to(bitmap, .5, {y: bitmap.y + 50, alpha: 0, ease: Strong.easeIn, delay: 1});
				}});
			}
		}
		
		override public function dispose():void
		{
			bitmap.bitmapData = null;
			bitmap = null;
			bd = null;
			super.dispose();
		}

		public function get phase():int
		{
			return _phase;
		}

	}
}