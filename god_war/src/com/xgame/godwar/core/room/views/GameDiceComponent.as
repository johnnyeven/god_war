package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class GameDiceComponent extends Component
	{
		private var mc: MovieClip;
		private var _value: int;
		
		public function GameDiceComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.base.Dice", null, false) as DisplayObjectContainer);
			
			mc = getSkin("dice") as MovieClip;
			mc.gotoAndStop(1);
			
			addChild(mc);
		}
		
		public function dice(value: int): void
		{
			value = Math.max(value, 1);
			value = Math.min(value, 6);
			
			_value = value;
			mc.play();
			TimerManager.instance.add(1000, onDice);
		}
		
		private function onDice(): void
		{
			var i: int = _value * 2 - 1;
			mc.gotoAndStop(i);
			
			TimerManager.instance.remove(onDice);
//			GameManager.instance.removeView(this);
		}
	}
}