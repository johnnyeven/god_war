package com.xgame.godwar.events.ui
{
	import com.xgame.godwar.liteui.component.ListItem;
	
	import flash.events.Event;
	
	public class ListEvent extends Event
	{
		public static const ITEM_CLICK: String = "ListEvent.ItemClick";
		public var item: ListItem;
		
		public function ListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}