package com.xgame.godwar.core.initialization
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadSoulCardConfigCommand extends SimpleCommand
	{
		public static const LOAD_NOTE: String = "LoadSoulCardConfigCommand";
		
		public function LoadSoulCardConfigCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
		}
	}
}