package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.general.proxy.ServerListProxy;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class ServerComponent extends Component
	{
		private var _txtCaption: Label;
		private var _btnBack: Button;
		private var _selectedFrame: ServerItemSelectedComponent;
		
		public function ServerComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ServerWindowSkin", null, false) as DisplayObjectContainer);
			
			_txtCaption = getUI(Label, "caption") as Label;
			_btnBack = getUI(Button, "back") as Button;
			
			sortChildIndex();
			
			_selectedFrame = new ServerItemSelectedComponent();
		}
		
		public function showServerList(container: Vector.<ServerListParameter>): void
		{
			if(container != null && container.length > 0)
			{
				var offsetX: int = 108;
				var point1: Point = new Point(40, 110);
				var point2: Point = new Point();
				for(var i: int = 0; i<container.length; i++)
				{
					var _item: ServerItemComponent = new ServerItemComponent(container[i], _selectedFrame);
					if(container[i].recommand)
					{
						_item.x = point1.x;
						_item.y = point1.y;
						
						point1.x += _item.width + offsetX;
					}
					else
					{
						_item.x = point2.x;
						_item.y = point2.y;
					}
					addChild(_item);
				}
			}
		}
	}
}