package com.xgame.godwar.core.general.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	public class TimerComponent extends Component
	{
		private var tmp: Array = [
			"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"
		];
		private var numericList: Vector.<BitmapData>;
		
		public function TimerComponent()
		{
			super(null);
			
			numericList = new Vector.<BitmapData>();
			
			var bd: BitmapData;
			for(var i: int = 0; i<10; i++)
			{
				bd = ResourcePool.instance.getBitmapData("assets.ui.numeric." + tmp[i]);
				numericList.push(bd);
			}
		}
	}
}