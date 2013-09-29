package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Radio;
	import com.xgame.godwar.liteui.component.RadioGroup;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class ChooseModeComponent extends Component
	{
		private var _btnMode1: Radio;
		private var _btnMode2: Radio;
		private var _group: RadioGroup;
		
		public function ChooseModeComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ChooseModeComponent", null, false) as DisplayObjectContainer);
			
			_group = new RadioGroup();
			_btnMode1 = getUI(Radio, "btnMode1") as Radio;
			_btnMode2 = getUI(Radio, "btnMode2") as Radio;
			
			_group.addRadio(_btnMode1);
			_group.addRadio(_btnMode2);
			
			_btnMode1.checked = true;
		}
	}
}