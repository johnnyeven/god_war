package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameOtherRoleSkillComponent extends Component
	{
		private var skillBorder: MovieClip;
		private var skillBorderNormal: MovieClip;
		private var skillBorderHighlight: MovieClip;
		private var skillMask: MovieClip;
		private var skillContainer: ImageContainer;
		
		public function BattleGameOtherRoleSkillComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameOtherRoleSkillComponent", null, false) as DisplayObjectContainer);
			
			skillContainer = getUI(ImageContainer, "skillContainer") as ImageContainer;
			skillBorder = getSkin("skillBorder") as MovieClip;
			skillMask = getSkin("skillMask") as MovieClip;
			skillBorderNormal = skillBorder.getChildByName("normal") as MovieClip;
			skillBorderHighlight = skillBorder.getChildByName("highlight") as MovieClip;
			
			sortChildIndex();
			
			skillContainer.mask = skillMask;
			skillBorderHighlight.visible = false;
		}
	}
}