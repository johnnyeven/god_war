package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	public class ServerItemComponent extends Component
	{
		private var _silverRiver1: MovieClip;
		private var _silverRiver2: MovieClip;
		private var _lblServerName: Label;
		private var _selectedFrame: ServerItemSelectedComponent;
		private var _parameter: ServerListParameter;
		
		public function ServerItemComponent(parameter: ServerListParameter, selectedComponent: ServerItemSelectedComponent)
		{
			_selectedFrame = selectedComponent;
			if(parameter != null)
			{
				super(ResourcePool.instance.getDisplayObject("assets.ui.login.ServerItemSkin", null, false) as DisplayObjectContainer);
				
				_parameter = parameter;
				_silverRiver1 = getSkin("silverRiver1") as MovieClip;
				_silverRiver2 = getSkin("silverRiver2") as MovieClip;
				_lblServerName = getUI(Label, "lblServerName") as Label;
				
				_silverRiver1.visible = false;
				_silverRiver2.visible = false;
				
				if(parameter.hot)
				{
					_silverRiver2.visible = true;
				}
				else
				{
					_silverRiver1.visible = true;
				}
				_lblServerName.text = parameter.name;
				
				sortChildIndex();
				
				addEventListener(MouseEvent.CLICK, onServerClick);
			}
			else
			{
				throw new IllegalOperationError("[Error]<ServerItemComponent>: CServerListParameter必须定义");
			}
		}
		
		private function onServerClick(evt: MouseEvent): void
		{
			if(_selectedFrame != null)
			{
				_selectedFrame.serverListParameter = _parameter;
				addChild(_selectedFrame);
			}
		}
	}
}