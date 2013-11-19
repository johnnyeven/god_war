package com.xgame.godwar.core.setting.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestCardGroup;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestCardGroup;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CardGroupProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "CardGroupProxy";
		
		public function CardGroupProxy()
		{
			super(NAME, null);
			
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_CARD_GROUP, Receive_Hall_RequestCardGroup);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_CARD_GROUP, onRequestCardGroup);
		}
		
		public function requestCardGroup(): void
		{
			if(CommandCenter.instance.connected)
			{
				sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				
				var protocol: Send_Hall_RequestCardGroup = new Send_Hall_RequestCardGroup();
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onRequestCardGroup(protocol: Receive_Hall_RequestCardGroup): void
		{
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			setData(protocol);
		}
	}
}