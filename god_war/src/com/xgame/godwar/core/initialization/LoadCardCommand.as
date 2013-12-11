package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.general.proxy.SoulProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadCardCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadCardCommand";
		
		public function LoadCardCommand()
		{
			super();
			facade.registerProxy(new SoulProxy());
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_NOTE);
			
			var _proxy: SoulProxy = facade.retrieveProxy(SoulProxy.NAME) as SoulProxy;
			_proxy.getConfig();
		}
	}
}