package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.login.mediators.ChooseModeMediator;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.Radio;
	import com.xgame.godwar.liteui.component.RadioGroup;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ChooseModeComponent extends Component
	{
		private var _btnMode1: Radio;
		private var _btnMode2: Radio;
		private var _group: RadioGroup;
		private var _textPanel: Component;
		private var _btnEnter: CaptionButton;
		private var _text1: Label;
		private var _text2: Label;
		private var _mode: int = 0;
		
		public function ChooseModeComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.ChooseModeComponent", null, false) as DisplayObjectContainer);
			
			_group = new RadioGroup();
			_btnMode1 = getUI(Radio, "btnMode1") as Radio;
			_btnMode2 = getUI(Radio, "btnMode2") as Radio;
			_textPanel = getUI(Component, "textPanel") as Component;
			_btnEnter = _textPanel.getUI(CaptionButton, "btnEnter") as CaptionButton;
			_text1 = _textPanel.getUI(Label, "text1") as Label;
			_text2 = _textPanel.getUI(Label, "text2") as Label;
			_text2.visible = false;
			_textPanel.sortChildIndex();
			sortChildIndex();
			
			_group.addRadio(_btnMode1);
			_group.addRadio(_btnMode2);
			
			_btnMode1.checked = true;
			
			_btnMode1.addEventListener(MouseEvent.CLICK, onBtnMode1Click);
			_btnMode2.addEventListener(MouseEvent.CLICK, onBtnMode2Click);
			_btnEnter.addEventListener(MouseEvent.CLICK, onBtnEnterClick);
		}
		
		private function onBtnMode1Click(evt: MouseEvent): void
		{
			_mode = 1;
			_text1.visible = true;
			_text2.visible = false;
		}
		
		private function onBtnMode2Click(evt: MouseEvent): void
		{
			_mode = 0;
			_text1.visible = false;
			_text2.visible = true;
		}
		
		private function onBtnEnterClick(evt: MouseEvent): void
		{
			ApplicationFacade.getInstance().sendNotification(ChooseModeMediator.ENTER_NOTE, _mode);
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .6, {x: -1028, ease: Strong.easeIn, onComplete: callback});
		}
	}
}