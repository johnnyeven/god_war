package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BattleRoomHeroComponent extends Component
	{
		private var avatarMask: MovieClip;
		private var imgAvatar: ImageContainer;
		private var selectedMc: MovieClip;
		private var _selected: Boolean = false;
		private var parameter: HeroCardParameter;
		
		public function BattleRoomHeroComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleRoomHeroComponent", null, false) as DisplayObjectContainer);
			
			imgAvatar = getUI(ImageContainer, "imgAvatar") as ImageContainer;
			avatarMask = getSkin("avatarMask") as MovieClip;
			selectedMc = getSkin("selected") as MovieClip;
			
			sortChildIndex();
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			imgAvatar.mask = avatarMask;
			selectedMc.visible = false;
		}
		
		public function set heroCardParameter(value: HeroCardParameter): void
		{
			if(value != null)
			{
				parameter = value;
				
				imgAvatar.source = parameter.avatarPath;
			}
		}
		
		public function get heroCardParameter(): HeroCardParameter
		{
			return parameter;
		}
		
		override protected function onMouseOver(evt: MouseEvent): void
		{
			if(_enabled)
			{
				UIUtils.setBrightness(this, 0.2);
			}
		}
		
		override protected function onMouseOut(evt: MouseEvent): void
		{
			if(_enabled)
			{
				UIUtils.setBrightness(this, 0);
			}
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if(_selected)
			{
				selectedMc.visible = true;
			}
			else
			{
				selectedMc.visible = false;
			}
		}

	}
}