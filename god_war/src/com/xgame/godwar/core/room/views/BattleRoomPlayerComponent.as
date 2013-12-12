package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleRoomPlayerComponent extends Component
	{
		private var lblName: Label;
		private var lblRateCaption: Label;
		private var lblRate: Label;
		private var lblHonorCaption: Label;
		private var lblHonor: Label;
		private var avatar: ImageContainer;
		private var avatarMask: MovieClip;
		private var normalSkin: MovieClip;
		private var ownerSkin: MovieClip;
		private var _ready: MovieClip;
		private var _player: Player;
		
		public function BattleRoomPlayerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleRoomPlayerComponent", null, false) as DisplayObjectContainer);
			
			lblName = getUI(Label, "lblName") as Label;
			lblRateCaption = getUI(Label, "lblRateCaption") as Label;
			lblRate = getUI(Label, "lblRate") as Label;
			lblHonorCaption = getUI(Label, "lblNickNameCaption") as Label;
			lblHonor = getUI(Label, "lblNickName") as Label;
			avatar = getUI(ImageContainer, "avatar") as ImageContainer;
			avatarMask = getSkin("avatarMask") as MovieClip;
			ownerSkin = getSkin("owner") as MovieClip;
			normalSkin = getSkin("normal") as MovieClip;
			_ready = getSkin("ready") as MovieClip;
			
			sortChildIndex();
			
			avatar.mask = avatarMask;
			ownerSkin.visible = false;
			_ready.visible = false;
		}

		public function get player():Player
		{
			return _player;
		}

		public function set player(value:Player):void
		{
			_player = value;
			
			lblName.text = _player.name;
			lblRate.text = _player.winningRate * 100 + "%";
			lblHonor.text = String(_player.honor);
			if(StringUtils.empty(_player.heroCardPath))
			{
				avatar.source = _player.avatarNormalPath;
			}
			else
			{
				avatar.source = _player.heroCardPath;
			}
			isOwner = value.isOwner;
		}
		
		public function set isOwner(value: Boolean): void
		{
			if(value)
			{
				ownerSkin.visible = true;
				normalSkin.visible = false;
			}
			else
			{
				ownerSkin.visible = false;
				normalSkin.visible = true;
			}
		}
		
		public function set ready(value: Boolean): void
		{
			if(value)
			{
				_ready.visible = true;
				
				lblRateCaption.visible = false;
				lblRate.visible = false;
				lblHonorCaption.visible = false;
				lblHonor.visible = false;
			}
			else
			{
				_ready.visible = false;
				
				lblRateCaption.visible = true;
				lblRate.visible = true;
				lblHonorCaption.visible = true;
				lblHonor.visible = true;
			}
		}
		
		public function set avatarImage(value: String): void
		{
			avatar.source = value
		}

	}
}