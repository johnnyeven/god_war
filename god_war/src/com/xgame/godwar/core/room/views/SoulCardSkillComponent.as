package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.object.Skill;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class SoulCardSkillComponent extends Component
	{
		private var lblCaption: Label;
		private var imgAvatar: ImageContainer;
		private var _skill: Skill;
		private var _card: SoulCard;
		
		public function SoulCardSkillComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.card.SoulCardSkillComponent") as DisplayObjectContainer);
			
			imgAvatar = getUI(ImageContainer, "avatar") as ImageContainer;
			lblCaption = getUI(Label, "caption") as Label;
			
			sortChildIndex();
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			UIUtils.setBrightness(this, .2);
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			UIUtils.setBrightness(this, 0);
		}

		public function get skill():Skill
		{
			return _skill;
		}

		public function set skill(value:Skill):void
		{
			_skill = value;
			if(_skill != null)
			{
				imgAvatar.source = _skill.resource;
				lblCaption.text = _skill.name;
			}
		}

		public function get card():SoulCard
		{
			return _card;
		}

		public function set card(value:SoulCard):void
		{
			_card = value;
		}


	}
}