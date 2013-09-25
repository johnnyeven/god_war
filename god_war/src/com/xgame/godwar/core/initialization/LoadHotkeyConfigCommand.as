package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import com.xgame.godwar.core.general.proxy.HotkeyProxy;
	
	public class LoadHotkeyConfigCommand extends SimpleCommand
	{
		public static const LOAD_HOTKEY_CONFIG_NOTE: String = "LoadHotkeyConfigCommand.LoadHotkeyConfigNote";
		
		public function LoadHotkeyConfigCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_HOTKEY_CONFIG_NOTE);
			facade.sendNotification(LoadingIconMediator.LOADING_SET_TITLE_NOTE, LanguageManager.getInstance().lang("load_hotkey_config"));
			
			var _proxy: HotkeyProxy = new HotkeyProxy();
			facade.registerProxy(_proxy);
			
			_proxy.requestHotkey();
		}
	}
}