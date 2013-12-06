package com.xgame.godwar
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xgame.godwar.core.general.mediators.MainMediator;
	import com.xgame.godwar.core.general.proxy.KeepAliveProxy;
	import com.xgame.godwar.core.initialization.LoadResourcesConfigCommand;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.loading.mediators.ProgressBarMediator;
	
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
			
			TweenPlugin.activate([TransformAroundCenterPlugin]);
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
			
			facade.sendNotification(LoadResourcesConfigCommand.LOAD_RESOURCE_CONFIG);
		}
		
		private function initCommand(): void
		{
			facade.registerCommand(LoadResourcesConfigCommand.LOAD_RESOURCE_CONFIG, LoadResourcesConfigCommand);
		}
		
		private function initMediator(): void
		{
			facade.registerMediator(new MainMediator(_main));
			facade.registerMediator(new LoadingIconMediator());
			facade.registerMediator(new ProgressBarMediator());
		}
		
		private function initProxy(): void
		{
			facade.registerProxy(new KeepAliveProxy());
		}
		
	}
}