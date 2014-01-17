package test
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import test.controllers.TestEffectCommand;
	import test.controllers.TestRotationCommand;
	
	public class TestApplicationCommand extends SimpleCommand
	{
		public static const START_TEST_COMMAND: String = "TestApplicationCommand.StartTestCommand";
		
		private var _main: main;
		
		public function TestApplicationCommand()
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
			
			facade.sendNotification(TestEffectCommand.NAME);
		}
		
		private function initCommand(): void
		{
			facade.registerCommand(TestEffectCommand.NAME, TestEffectCommand);
			facade.registerCommand(TestRotationCommand.NAME, TestRotationCommand);
		}
		
		private function initMediator(): void
		{
			
		}
		
		private function initProxy(): void
		{
			
		}
	}
}