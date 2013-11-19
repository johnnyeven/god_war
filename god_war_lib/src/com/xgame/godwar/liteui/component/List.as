package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class List extends Component
	{
		private var scrollList: ScrollBar;
		private var container: Container;
		
		public function List(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			scrollList = getUI(ScrollBar, "scrollList") as ScrollBar;
			container = getUI(Container, "container") as Container;
		}
		
		public function add(item: ListItem): void
		{
			
		}
		
		public function remove(item: ListItem): void
		{
			
		}
	}
}