package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadAvatarConfigCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadAvatarConfigCommand";
		
		public function LoadAvatarConfigCommand()
		{
			super();
			
			if(!facade.hasProxy(AvatarConfigProxy.NAME))
			{
				facade.registerProxy(new AvatarConfigProxy());
			}
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_NOTE);
			
			var _proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			_proxy.getAvatarConfig();
		}
	}
}