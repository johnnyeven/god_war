package test.controllers
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class TestRotationCommand extends SimpleCommand
	{
		public static const NAME: String = "TestRotationCommand";
		
		public function TestRotationCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _loader: XMLLoader = new XMLLoader("config/zh_CN/resources.xml", {name:"resourcesConfig", onComplete:onLoadComplete});
			_loader.load();
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			ResourceCenter.instance.load("chaos_5_leitingjushou", null, onCardLoaded);
		}
		
		private function onCardLoaded(evt: LoaderEvent): void
		{
			var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.LeiTingJuShou_Small");
			var bitmap: Bitmap = new Bitmap(bd);
			var sp: Sprite = new Sprite();
			bitmap.x = -bitmap.width / 2;
			sp.addChild(bitmap);
			GameManager.instance.addBase(sp);
			sp.x = 514;
			sp.y = (600 - sp.height) / 2;
//			sp.rotationY = 180;
			
			TweenLite.to(sp, 5, {rotationY: 180});
		}
	}
}