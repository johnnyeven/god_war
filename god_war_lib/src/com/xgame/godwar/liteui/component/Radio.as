package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Radio extends Component
	{
		private var _statusCheck: Sprite;
		private var _statusUncheck: Sprite;
		private var _labelCaption: Label;
		private var _checked: Boolean = false;
		public var radioGroup: String = "default";
		
		public function Radio(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			_statusCheck = getSkin("check") as Sprite;
			_statusUncheck = getSkin("uncheck") as Sprite;
			_labelCaption = getUI(Label, "caption") as Label;
			
			_statusCheck.visible = false;
		}

		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			if(value)
			{
				_statusCheck.visible = true;
				_statusUncheck.visible = false;
				_checked = true;
			}
			else
			{
				_statusCheck.visible = false;
				_statusUncheck.visible = true;
				_checked = false;
			}
		}

	}
}