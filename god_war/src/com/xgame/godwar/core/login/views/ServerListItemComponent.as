package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.parameters.ServerListParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.initialization.InitGameSocketCommand;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	
	public class ServerListItemComponent extends Component
	{
		private var _mcRecommand: MovieClip;
		private var _mcStatusNormal: MovieClip;
		private var _mcStatusHot: MovieClip;
		private var _mcStatusBusy: MovieClip;
		private var _lblServerName: Label;
		private var _parameter: ServerListParameter;
		
		public function ServerListItemComponent(parameter: ServerListParameter)
		{
			if(parameter != null)
			{
				super(ResourcePool.instance.getDisplayObject("assets.ui.login.ServerListItemComponent", null, false) as DisplayObjectContainer);
				
				_parameter = parameter;
				_mcRecommand = getSkin("hot") as MovieClip;
				_mcStatusNormal = getSkin("statusNormal") as MovieClip;
				_mcStatusHot = getSkin("statusHot") as MovieClip;
				_mcStatusBusy = getSkin("statusBusy") as MovieClip;
				_lblServerName = getUI(Label, "caption") as Label;
				_lblServerName.text = parameter.name;
				
				_mcStatusNormal.visible = false;
				_mcStatusHot.visible = false;
				_mcStatusBusy.visible = false;
				
				if(parameter.hot)
				{
					_mcStatusHot.visible = true;
				}
				else
				{
					_mcStatusNormal.visible = true;
				}
				
				if(!parameter.recommand)
				{
					_mcRecommand.visible = false;
				}
				
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
			ApplicationFacade.getInstance().registerCommand(InitGameSocketCommand.CONNECT_SOCKET_NOTE, InitGameSocketCommand);
			ApplicationFacade.getInstance().sendNotification(InitGameSocketCommand.CONNECT_SOCKET_NOTE, _parameter);
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			
		}
	}
}