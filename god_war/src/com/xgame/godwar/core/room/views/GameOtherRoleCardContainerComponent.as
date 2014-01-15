package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class GameOtherRoleCardContainerComponent extends Component
	{
		private var _backContainer: Vector.<Sprite>;
		private var _cardContainer: Vector.<Card>;
		
		public function GameOtherRoleCardContainerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.GameOtherRoleCardContainerComponent", null, false) as DisplayObjectContainer);
		}
	}
}