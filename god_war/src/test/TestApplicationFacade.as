package test
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class TestApplicationFacade extends Facade
	{
		private var _main: main;
		public function TestApplicationFacade()
		{
			super();
		}
		
		public static function getInstance(): TestApplicationFacade
		{
			if(instance == null)
			{
				instance = new TestApplicationFacade();
			}
			return instance as TestApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(TestApplicationCommand.START_TEST_COMMAND, TestApplicationCommand);
		}
		
		public function start(app: main): void
		{
			sendNotification(TestApplicationCommand.START_TEST_COMMAND, app);
		}
	}
}