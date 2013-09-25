package com.xgame.godwar
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ApplicationCommand extends SimpleCommand
	{
		private var _main: main;
		private var _mouseX: Number;
		private var _mouseY: Number;
		
		public function ApplicationCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _lc: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			LoaderMax.activate([ImageLoader, SWFLoader]);
			LoaderMax.defaultContext = _lc;
			
			_main = notification.getBody() as main;
			
			initCommand();
			initMediator();
			initProxy();
			
//			facade.sendNotification(LoadResourcesConfigCommand.LOAD_RESOURCE_CONFIG);
		}
		
		private function initCommand(): void
		{
			
		}
		
		private function initMediator(): void
		{
			
		}
		
		private function initProxy(): void
		{
			
		}
		
	}
}