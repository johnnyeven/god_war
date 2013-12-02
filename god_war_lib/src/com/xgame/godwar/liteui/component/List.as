package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.events.ui.ListEvent;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class List extends Component
	{
		private var scrollList: ScrollBar;
		private var container: Container;
		private var _list: Vector.<ListItem>;
		private var _value: Object;
		
		public function List(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			_list = new Vector.<ListItem>();
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			container = getUI(Container, "container") as Container;
			
			sortChildIndex();
			
			container.layout = new HorizontalTileLayout(container);
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = container;
		}
		
		public function get list():Vector.<ListItem>
		{
			return _list;
		}

		public function add(item: ListItem): void
		{
			if(_list.indexOf(item) >= 0)
			{
				return;
			}
			item.addEventListener(MouseEvent.CLICK, onItemClick);
			_list.push(item);
			container.add(item);
			container.layout.update();
			scrollList.rebuild();
		}
		
		public function remove(item: ListItem): void
		{
			var index: int = _list.indexOf(item);
			if(index >= 0)
			{
				item.removeEventListener(MouseEvent.CLICK, onItemClick);
				_list.splice(index, 1);
				container.remove(item);
				container.layout.update();
				scrollList.rebuild();
			}
		}
		
		public function removeAll(): void
		{
			for(var i: String in _list)
			{
				_list[i].dispose();
			}
			_list.splice(0, _list.length);
			container.removeAll();
			container.layout.update();
			scrollList.rebuild();
		}
		
		private function onItemClick(evt: MouseEvent): void
		{
			for(var i: int = 0; i < _list.length; i++)
			{
				_list[i].status = false;
			}
			var item: ListItem = evt.currentTarget as ListItem;
			item.status = true;
			_value = item.value;
			
			evt.stopImmediatePropagation();
			
			var event: ListEvent = new ListEvent(ListEvent.ITEM_CLICK);
			event.item = item;
			dispatchEvent(event);
		}

		public function get value():Object
		{
			return _value;
		}

	}
}