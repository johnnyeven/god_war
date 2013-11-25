package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.List;
	import com.xgame.godwar.liteui.component.ListItem;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class CardGroupListComponent extends Component
	{
		private var lblTitle: Label;
		private var lstGroup: List;
		private var btnAddGroup: Button;
		private var btnDeleteGroup: Button;
		
		public function CardGroupListComponent(_skin: DisplayObjectContainer = null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CardGroupListComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			lstGroup = getUI(List, "lstGroup") as List;
			btnAddGroup = getUI(Button, "btnAddGroup") as Button;
			btnDeleteGroup = getUI(Button, "btnDeleteGroup") as Button;
			
			lstGroup.addEventListener(MouseEvent.CLICK, onListClick);
		}
		
		public function addGroup(item: CardGroupParameter): void
		{
			var i: ListItem = new ListItem(ResourcePool.instance.getDisplayObject("assets.ui.config.CardGroupListItem", null, false) as DisplayObjectContainer);
			i.title = item.groupName;
			i.value = item.groupId;
			lstGroup.add(i);
		}
		
		private function onListClick(evt: MouseEvent): void
		{
			trace(evt.currentTarget);
		}
	}
}