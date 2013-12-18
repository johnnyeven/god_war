package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.ImageContainer;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameMainRoleSkillComponent extends Component
	{
		private var btnSkill: Button;
		private var skillMask: MovieClip;
		private var skillContainer: ImageContainer;
		
		public function BattleGameMainRoleSkillComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameMainRoleSkillComponent", null, false) as DisplayObjectContainer);
			
			btnSkill = getUI(Button, "btnSkill") as Button;
			skillContainer = getUI(ImageContainer, "skillContainer") as ImageContainer;
			skillMask = getSkin("skillMask") as MovieClip;
			
			sortChildIndex();
			
			skillContainer.mask = skillMask;
		}
	}
}