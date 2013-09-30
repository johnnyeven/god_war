package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.LoginEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ServerComponent extends Component
	{
		private var _btnPrev: Button;
		private var _btnNext: Button;
		private var _btnBack: CaptionButton;
		
		public function ServerComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ServerComponent", null, false) as DisplayObjectContainer);
			
			_btnPrev = getUI(Button, "btnPrev") as Button;
			_btnNext = getUI(Button, "btnNext") as Button;
			_btnBack = getUI(CaptionButton, "btnBack") as CaptionButton;
			
			sortChildIndex();
			
			_btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
		}
		
		private function onBtnBackClick(evt: MouseEvent): void
		{
			dispatchEvent(new LoginEvent(LoginEvent.SERVERLIST_BACK_EVENT));
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .6, {x: -1028, ease: Strong.easeIn, onComplete: callback});
		}
		
		public function showServerList(container: Vector.<ServerListParameter>): void
		{
			if(container != null && container.length > 0)
			{
				var offsetX: int = 70;
				var offsetY: int = 0;
				var point1: Point = new Point(160, 220);
				for(var i: int = 0; i<container.length; i++)
				{
					var _item: ServerListItemComponent = new ServerListItemComponent(container[i]);
					
					_item.x = point1.x;
					_item.y = point1.y;
					
					if((i-1) % 2 == 0)
					{
						point1.x = 160;
						point1.y += _item.height + offsetY;
					}
					else
					{
						point1.x += _item.width + offsetX;
					}
					
					addChild(_item);
				}
			}
		}
	}
}