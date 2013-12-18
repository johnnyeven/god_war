package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameOtherRoleComponent extends Component
	{
		private var avatarMask: MovieClip;
		private var avatarContainer: ImageContainer;
		private var healthBar: MovieClip;
		
		public function BattleGameOtherRoleComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameOtherRoleComponent", null, false) as DisplayObjectContainer);
			
			avatarContainer = getUI(ImageContainer, "avatarContainer") as ImageContainer;
			avatarMask = getSkin("avatarMask") as MovieClip;
			healthBar = getSkin("healthBar") as MovieClip;
			
			sortChildIndex();
			
			avatarContainer.mask = avatarMask;
			healthBar.gotoAndStop(1000);
		}
	}
}