package test
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class TestDice extends Facade
	{
		private var _main: main;
		public function TestDice()
		{
			super();
		}
		
		public static function getInstance(): TestDice
		{
			if(instance == null)
			{
				instance = new TestDice();
			}
			return instance as TestDice;
		}
		
		public function start(app: main): void
		{
			_main = app;
			var _loader: XMLLoader = new XMLLoader("config/zh_CN/resources.xml", {name:"resourcesConfig", onComplete:onLoadComplete});
			_loader.load();
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			ResourceCenter.instance.load("login_ui_batch", null, onResourceLoaded, onLoadProgress, onLoadIOError);
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			var component: GameDiceComponent = new GameDiceComponent();
			_main.addBase(component);
			
			component.dice(2);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
		}
		
		private function onLoadIOError(evt: LoaderEvent): void
		{
		}
	}
}