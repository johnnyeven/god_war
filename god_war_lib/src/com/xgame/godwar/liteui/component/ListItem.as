package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ListItem extends Component
	{
		private var _title: Label;
		private var _value: Object;
		private var normal: MovieClip;
		private var highlight: MovieClip;
		private var selected: MovieClip;
		private var _status: Boolean = false;
		
		public function ListItem(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			_title = getUI(Label, "title") as Label;
			normal = getSkin("normal") as MovieClip;
			highlight = getSkin("highlight") as MovieClip;
			selected = getSkin("selected") as MovieClip;
			
			setMouseNormalSkin();
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			if(!_status)
			{
				setMouseOverSkin();
			}
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			if(!_status)
			{
				setMouseNormalSkin();
			}
		}
		
		protected function hideAllStatu(): void
		{
			normal.visible = false;
			highlight.visible = false;
			selected.visible = false;
		}
		
		protected function setMouseOverSkin(): void
		{
			hideAllStatu();
			highlight.visible = true;
		}
		
		protected function setMouseDownSkin(): void
		{
			hideAllStatu();
			selected.visible = true;
		}
		
		protected function setMouseNormalSkin(): void
		{
			hideAllStatu();
			normal.visible = true;
		}

		public function get status():Boolean
		{
			return _status;
		}

		public function set status(value:Boolean):void
		{
			_status = value;
			if(_status)
			{
				setMouseDownSkin();
			}
			else
			{
				setMouseNormalSkin();
			}
		}

		public function get value():Object
		{
			return _value;
		}

		public function set value(value:Object):void
		{
			_value = value;
		}

		public function get title():String
		{
			return _title.text;
		}

		public function set title(value:String):void
		{
			_title.text = value;
		}


	}
}