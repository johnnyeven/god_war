package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class LoginBGComponent extends Component
	{
		private var bg1: MovieClip;
		private var bg2: MovieClip;
		
		public function LoginBGComponent()
		{
			super(ResourcePool.instance.getDisplayObject('assets.ui.login.LoginBG', null, false) as DisplayObjectContainer);
			
			bg1 = getSkin("bg1") as MovieClip;
			bg2 = getSkin("bg2") as MovieClip;
			
			bg2.alpha = 0;
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
		
		public function change(type: int): void
		{
			if(type == 2)
			{
				TweenLite.to(bg1, .3, {alpha: 0, onComplete: function(): void
				{
					TweenLite.to(bg2, .3, {alpha: 1});
				}});
			}
			else
			{
				TweenLite.to(bg2, .3, {alpha: 0, onComplete: function(): void
				{
					TweenLite.to(bg1, .3, {alpha: 1});
				}});
			}
		}
	}
}