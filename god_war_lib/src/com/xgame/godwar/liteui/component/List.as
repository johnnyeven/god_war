package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	
	public class List extends Component
	{
		private var scrollList: ScrollBar;
		private var container: Container;
		private var list: Vector.<ListItem>;
		
		public function List(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			list = new Vector.<ListItem>();
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			container = getUI(Container, "container") as Container;
			
			sortChildIndex();
			
			container.layout = new HorizontalTileLayout(container);
			scrollList.orientation = ScrollBarOrientation.VERTICAL;
			scrollList.view = container;
		}
		
		public function add(item: ListItem): void
		{
			if(list.indexOf(item) >= 0)
			{
				return;
			}
			list.push(item);
			container.add(item);
			container.layout.update();
			scrollList.rebuild();
		}
		
		public function remove(item: ListItem): void
		{
			var index: int = list.indexOf(item);
			if(index >= 0)
			{
				list.splice(index, 1);
				container.remove(item);
				container.layout.update();
				scrollList.rebuild();
			}
		}
	}
}