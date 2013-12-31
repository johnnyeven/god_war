package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameOtherRoleComponent extends Component
	{
		private var avatarMask: MovieClip;
		private var avatarContainer: ImageContainer;
		private var healthMy: MovieClip;
		private var healthOther: MovieClip;
		private var healthBar: MovieClip;
		private var deploy: MovieClip;
		private var _player: Player;
		
		public function BattleGameOtherRoleComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameOtherRoleComponent", null, false) as DisplayObjectContainer);
			
			avatarContainer = getUI(ImageContainer, "avatarContainer") as ImageContainer;
			avatarMask = getSkin("avatarMask") as MovieClip;
			healthMy = getSkin("healthMy") as MovieClip;
			healthOther = getSkin("healthOther") as MovieClip;
			deploy = getSkin("deploy") as MovieClip;
			
			sortChildIndex();
			
			avatarContainer.mask = avatarMask;
			healthMy.gotoAndStop(1000);
			healthOther.gotoAndStop(1000);
			deploy.visible = false;
			
			healthBar = healthMy;
		}
		
		public function switchHealthBar(value: Boolean): void
		{
			if(value)
			{
				healthMy.visible = true;
				healthOther.visible = false;
				healthBar = healthMy;
			}
			else
			{
				healthMy.visible = false;
				healthOther.visible = true;
				healthBar = healthOther;
			}
		}

		public function get player():Player
		{
			return _player;
		}

		public function set player(value:Player):void
		{
			_player = value;
			
			avatarContainer.source = _player.heroCardPath;
		}

		public function setDeploy(value: Boolean): void
		{
			if(value)
			{
				deploy.visible = true;
			}
			else
			{
				deploy.visible = false;
			}
		}
	}
}