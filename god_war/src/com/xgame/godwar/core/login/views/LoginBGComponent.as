package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class LoginBGComponent extends Component
	{
		public function LoginBGComponent()
		{
			super(ResourcePool.instance.getDisplayObject('assets.ui.login.LoginBG', null, false) as DisplayObjectContainer);
		}
		
		public function show(): void
		{
			alpha = 0;
			TweenLite.to(this, 1, {alpha: 1});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, 1, {alpha: 0, onComplete: callback});
		}
		
		public function change(): void
		{
			
		}
	}
}