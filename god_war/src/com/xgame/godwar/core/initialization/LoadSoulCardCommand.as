package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.general.proxy.SoulCardProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadSoulCardCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadSoulCardCommand";
		
		public function LoadSoulCardCommand()
		{
			super();
			facade.registerProxy(new SoulCardProxy());
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_NOTE);
			
			var _proxy: SoulCardProxy = facade.retrieveProxy(SoulCardProxy.NAME) as SoulCardProxy;
			_proxy.getConfig();
		}
	}
}