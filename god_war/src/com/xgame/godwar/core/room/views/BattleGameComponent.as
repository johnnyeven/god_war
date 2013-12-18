package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleGameComponent extends Component
	{
		private var lblZhenxing: Label;
		private var chatComponent: BattleGameChatComponent;
		private var panelComponent: BattleGamePanalComponent;
		
		public function BattleGameComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameComponent", null, false) as DisplayObjectContainer);
			
			lblZhenxing = getUI(Label, "lblZhenxing") as Label;
			chatComponent = getUI(BattleGameChatComponent, "chatComponent") as BattleGameChatComponent;
			panelComponent = getUI(BattleGamePanalComponent, "panelComponent") as BattleGamePanalComponent;
		}
	}
}