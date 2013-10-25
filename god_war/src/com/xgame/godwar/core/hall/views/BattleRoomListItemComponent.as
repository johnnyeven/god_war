package com.xgame.godwar.core.hall.views
{
	import com.xgame.godwar.common.parameters.RoomListItemParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleRoomListItemComponent extends Component
	{
		private var lblId: Label;
		private var lblTitle: Label;
		private var lblOwner: Label;
		private var lblPeople: Label;
		private var _info: RoomListItemParameter;
		
		public function BattleRoomListItemComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.hall.BattleRoomListItemComponent", null, false) as DisplayObjectContainer);
			
			lblId = getUI(Label, "id") as Label;
			lblTitle = getUI(Label, "title") as Label;
			lblOwner = getUI(Label, "owner") as Label;
			lblPeople = getUI(Label, "people") as Label;
			
			sortChildIndex();
		}

		public function get info():RoomListItemParameter
		{
			return _info;
		}

		public function set info(value:RoomListItemParameter):void
		{
			_info = value;
			lblId.text = _info.id.toString();
			lblTitle.text = _info.title;
			lblOwner.text = _info.ownerName;
			lblPeople.text = _info.peopleCount + "/" + _info.peopleLimit;
		}

	}
}