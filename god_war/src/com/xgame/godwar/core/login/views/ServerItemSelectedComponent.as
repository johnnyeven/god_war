package com.xgame.godwar.core.login.views
{
	import controllers.init.InitGameSocketCommand;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import parameters.ServerListParameter;
	
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.common.pool.ResourcePool;
	
	public class ServerItemSelectedComponent extends Component
	{
		private var lblDelayTitle: Label;
		private var lblDelay: Label;
		private var btnEnter: CaptionButton;
		private var _serverListParameter: ServerListParameter;
		
		public function ServerItemSelectedComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ServerItemSelectedSkin", null, false) as DisplayObjectContainer);
			
			lblDelayTitle = getUI(Label, "lblDelay") as Label;
			lblDelay = getUI(Label, "delay") as Label;
			btnEnter = getUI(CaptionButton, "btnEnter") as CaptionButton;
			
			btnEnter.addEventListener(MouseEvent.CLICK, onBtnEnterClick);
		}
		
		public function set serverListParameter(value: ServerListParameter): void
		{
			if(value != null && value != _serverListParameter)
			{
				_serverListParameter = value;
				updateUI();
			}
		}
		
		private function updateUI(): void
		{
			if(_serverListParameter != null)
			{
				
			}
		}
		
		private function onBtnEnterClick(evt: MouseEvent): void
		{
			ApplicationFacade.getInstance().registerCommand(InitGameSocketCommand.CONNECT_SOCKET_NOTE, InitGameSocketCommand);
			ApplicationFacade.getInstance().sendNotification(InitGameSocketCommand.CONNECT_SOCKET_NOTE, _serverListParameter);
		}
	}
}