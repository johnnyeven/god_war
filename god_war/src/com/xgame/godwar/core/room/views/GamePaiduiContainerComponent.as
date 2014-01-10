package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class GamePaiduiContainerComponent extends Component
	{
		private var _lblCaption: Label;
		private var _btnOk: CaptionButton;
		private var _soulPaidui: GamePaiDuiComponent;
		private var _supplyPaidui: GamePaiDuiComponent;
		
		public function GamePaiduiContainerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.GamePaiduiContainerComponent", null, false) as DisplayObjectContainer);
			
			_lblCaption = getUI(Label, "caption") as Label;
			_btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
		}
	}
}