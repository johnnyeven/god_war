package com.xgame.godwar.core.initialization
{
	import com.xgame.godwar.core.general.proxy.SkillProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadSkillCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadSkillCommand";
		
		public function LoadSkillCommand()
		{
			super();
			facade.registerProxy(new SkillProxy());
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeCommand(LOAD_NOTE);
			
			var _proxy: SkillProxy = facade.retrieveProxy(SkillProxy.NAME) as SkillProxy;
			_proxy.getConfig();
		}
	}
}