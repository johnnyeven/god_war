package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class CreateGroupComponent extends Component
	{
		public function CreateGroupComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CreateGroupComponent", null, false) as DisplayObjectContainer);
		}
	}
}