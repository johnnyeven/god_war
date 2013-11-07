package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.events.ui.MenuEvent;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.Margin;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Select extends Component
	{
		private var btnDropDown: Button;
//		private var _transparency: Sprite;
		private var dropDownList: Menu;
		private var lblCaption: Label;
		private var _value: * = null;
		
		public function Select(_skin:DisplayObjectContainer=null)
		{
			if(_skin == null)
			{
				_skin = ResourcePool.instance.getDisplayObject("com.xgame.godwar.ui.Select", null, false) as DisplayObjectContainer;
			}
			super(_skin);
			
			btnDropDown = getUI(Button, "btnSelect") as Button;
			lblCaption = getUI(Label, "caption") as Label;
			dropDownList = new Menu(ResourcePool.instance.getDisplayObject("com.xgame.godwar.ui.menu.BG", null, false) as DisplayObjectContainer);
			dropDownList.padding = new Margin(40, 60, 40, 60);
			
//			_transparency = new Sprite();
//			_transparency.graphics.beginFill(0x000000, 0);
//			_transparency.graphics.drawRect(0, 0, GameManager.container.stageWidth, GameManager.container.stageHeight);
//			_transparency.graphics.endFill();
//			_transparency.addEventListener(MouseEvent.CLICK, onTransparencyClick);
//			_transparency.visible = false;
			
			sortChildIndex();
			dropDownList.x = -10;
			dropDownList.y = height - 10;
			dropDownList.visible = false;
			addChild(dropDownList);
			
			var _item1: MenuItem = new MenuItem();
			_item1.itemName = "1v1";
			_item1.text = "1 vs 1";
			dropDownList.addItem(_item1, onMenuClick);
			_item1 = new MenuItem();
			_item1.itemName = "2v2";
			_item1.text = "2 vs 2";
			dropDownList.addItem(_item1, onMenuClick);
			_item1 = new MenuItem();
			_item1.itemName = "3v3";
			_item1.text = "3 vs 3";
			dropDownList.addItem(_item1, onMenuClick);
			_item1 = new MenuItem();
			_item1.itemName = "4v4";
			_item1.text = "4 vs 4";
			dropDownList.addItem(_item1, onMenuClick);
			_item1 = new MenuItem();
			_item1.itemName = "5v5";
			_item1.text = "5 vs 5";
			dropDownList.addItem(_item1, onMenuClick);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			btnDropDown.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			btnDropDown.dispatchEvent(evt);
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			btnDropDown.dispatchEvent(evt);
		}
		
		protected function onMouseClick(evt:MouseEvent): void
		{
			onButtonClick(evt);
		}
		
		protected function onButtonClick(evt:MouseEvent): void
		{
			toggleList();
//			toggleTransparency();
			evt.stopImmediatePropagation();
		}
		
		protected function onTransparencyClick(evt: MouseEvent): void
		{
			toggleList();
//			toggleTransparency();
			evt.stopImmediatePropagation();
		}
		
		private function toggleList(): void
		{
			if(dropDownList.visible)
			{
				dropDownList.visible = false;
			}
			else
			{
				dropDownList.visible = true;
			}
		}
		
//		private function toggleTransparency(): void
//		{
//			if(_transparency.visible)
//			{
//				_transparency.visible = false;
//			}
//			else
//			{
//				_transparency.visible = true;
//			}
//		}
		
		protected function onMenuClick(evt: MenuEvent): void
		{
			switch(evt.itemName)
			{
				case "1v1":
					lblCaption.text = "1 vs 1";
					_value = 2;
					break;
				case "2v2":
					lblCaption.text = "2 vs 2";
					_value = 4;
					break;
				case "3v3":
					lblCaption.text = "3 vs 3";
					_value = 6;
					break;
				case "4v4":
					lblCaption.text = "4 vs 4";
					_value = 8;
					break;
				case "5v5":
					lblCaption.text = "5 vs 5";
					_value = 10;
					break;
			}
			toggleList();
		}

		public function get value():*
		{
			return _value;
		}

	}
}