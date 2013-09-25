package
{
	import com.xgame.godwar.ApplicationCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade
	{
		public static const APP_START_NOTE: String = "ApplicationFacade.AppStartNote";
		
		public function ApplicationFacade()
		{
			super();
		}
		
		public static function getInstance(): ApplicationFacade
		{
			if(instance == null)
			{
				instance = new ApplicationFacade();
			}
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(APP_START_NOTE, ApplicationCommand);
		}
		
		public function start(app: main): void
		{
			sendNotification(APP_START_NOTE, app);
		}
	}
}