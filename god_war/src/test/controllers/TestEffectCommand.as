package test.controllers
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.display.renders.Render;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.Bitmap;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class TestEffectCommand extends SimpleCommand
	{
		public static const NAME: String = "TestEffectCommand";
		
		public function TestEffectCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var _loader: XMLLoader = new XMLLoader("config/zh_CN/resources.xml", {name:"resourcesConfig", onComplete:onLoadComplete});
			_loader.load();
			
			EffectCenter.instance.start();
		}
		
//		private function onLoadComplete(evt: LoaderEvent): void
//		{
//			ResourceCenter.instance.load("chaos_5_leitingjushou", null, onCardLoaded);
//			ResourceCenter.instance.load("effect_hero_human_jiasite1", null, onResourceLoaded);
//		}
//		
//		private function onCardLoaded(evt: LoaderEvent): void
//		{
//			var bitmap: Bitmap = new Bitmap(ResourcePool.instance.getBitmapData("assets.resource.card.LeiTingJuShou_Small"), "auto", true);
//			bitmap.width = 59;
//			bitmap.height = 90;
//			GameManager.instance.addBack(bitmap);
//			UIUtils.center(bitmap);
//		}
//		
//		private function onResourceLoaded(evt: LoaderEvent): void
//		{
//			var effect: BitmapMovieDispaly = new BitmapMovieDispaly();
//			effect.graphic = ResourcePool.instance.getResourceData("assets.effect.hero.human.Jiasite1");
//			var _render: Render = new Render();
//			effect.render = _render;
//			EffectCenter.instance.addEffect(effect);
//			
//			UIUtils.center(effect);
//		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			var bitmapMovie: BitmapMovieDispaly;
			bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
			GameManager.instance.addBack(bitmapMovie);
			EffectCenter.instance.addEffect(bitmapMovie);
			
			bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
			GameManager.instance.addBack(bitmapMovie);
			bitmapMovie.x = 94;
			EffectCenter.instance.addEffect(bitmapMovie);
			
			bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
			GameManager.instance.addBack(bitmapMovie);
			bitmapMovie.x = 94 * 2;
			EffectCenter.instance.addEffect(bitmapMovie);
			
			bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
			GameManager.instance.addBack(bitmapMovie);
			bitmapMovie.x = 94 * 3;
			EffectCenter.instance.addEffect(bitmapMovie);
		}
	}
}