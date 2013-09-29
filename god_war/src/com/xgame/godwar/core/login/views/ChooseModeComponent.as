package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class ChooseModeComponent extends Component
	{
		public function ChooseModeComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ChooseModeComponent", null, false) as DisplayObjectContainer);
		}
	}
}