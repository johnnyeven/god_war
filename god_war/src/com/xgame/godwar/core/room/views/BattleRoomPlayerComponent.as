package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
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
			
			sortChildIndex();
			
			avatar.mask = avatarMask;
			ownerSkin.visible = false;
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
			avatar.source = _player.avatarNormalPath;
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

	}
}