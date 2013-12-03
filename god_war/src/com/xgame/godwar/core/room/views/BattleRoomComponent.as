package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleRoomComponent extends Component
	{
		private var lblTitle: Label;
		private var btnCardConfig: CaptionButton;
		private var btnReady: CaptionButton;
		private var heroList: Container;
		private var heroListScroll: ScrollBar;
		
		public function BattleRoomComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.room.BattleRoomComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			btnCardConfig = getUI(CaptionButton, "btnCardConfig") as CaptionButton;
			btnReady = getUI(CaptionButton, "btnReady") as CaptionButton;
			heroList = getUI(Container, "lstContainer") as Container;
			heroListScroll = getUI(ScrollBar, "scrollList") as ScrollBar;
			
			sortChildIndex();
			
			heroList.layout = new HorizontalTileLayout(heroList);
			heroListScroll.orientation = ScrollBarOrientation.VERTICAL;
			heroListScroll.view = heroList;
		}
		
		public function show(callback: Function = null): void
		{
			y = -600;
			
			TweenLite.to(this, .5, {y: 0, ease: Strong.easeOut, onComplete: callback});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .5, {y: -600, ease: Strong.easeIn, onComplete: callback});
		}
	}
}