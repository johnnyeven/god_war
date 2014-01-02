package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class GameDiceComponent extends Component
	{
		private var mc: MovieClip;
		
		public function GameDiceComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.base.Dice") as DisplayObjectContainer);
			
			mc = getSkin("dice") as MovieClip;
			mc.stop();
		}
		
		public function dice(value: int): void
		{
			value = Math.max(value, 1);
			value = Math.min(value, 6);
		}
	}
}