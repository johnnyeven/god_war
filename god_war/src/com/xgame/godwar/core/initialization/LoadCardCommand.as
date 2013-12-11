package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.general.proxy.CardProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadCardCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadCardCommand";
		
		public function LoadCardCommand()
		{
			super();
			facade.registerProxy(new CardProxy());
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_NOTE);
			
			var _proxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
			_proxy.getConfig();
		}
	}
}