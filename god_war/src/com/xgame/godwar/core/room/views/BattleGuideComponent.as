package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.DropShadowFilter;
	
	public class BattleGuideComponent extends Component
	{
		private var _caption: Label;
		
		public function BattleGuideComponent()
		{
			super(null);
			
			_caption = new Label();
			_caption.size = 20;
			_caption.color = 0xFFFFFF;
			_caption.textWidth = 600;
			
			addChild(_caption);
			UIUtils.center(_caption);
			_caption.y += 100;
			_caption.visible = false;
		}
		
		public function show(callback: Function = null): void
		{
			_caption.visible = true;
			UIUtils.center(_caption);
			_caption.y += 100;
			TweenLite.from(_caption, .5, {y: _caption.y + 50, alpha: 0, ease: Strong.easeOut, onComplete: function(): void
			{
				if(callback != null)
				{
					callback();
				}
			}});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(_caption, .5, {y: _caption.y - 50, alpha: 0, ease: Strong.easeIn, onComplete: function(): void
			{
				_caption.visible = false;
				
				if(callback != null)
				{
					callback();
				}
			}});
		}
		
		public function set caption(value: String): void
		{
			if(value != _caption.text && value != null)
			{
				_caption.text = value;
			}
		}
		
		public function get caption(): String
		{
			return _caption.text;
		}
	}
}