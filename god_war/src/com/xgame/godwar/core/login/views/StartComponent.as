package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.LoginEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class StartComponent extends Component
	{
		private var _buttonStart: CaptionButton;
		private var _buttonLogin: CaptionButton;
		private var _buttonRegister: CaptionButton;
		private var _textAnnouncement: Component;
		private var _labelAnnouncementCaption: Label;
		private var _labelAnnouncementContent: Label;
		
		public function StartComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.StartComponent", null, false) as DisplayObjectContainer);
			_buttonStart = getUI(CaptionButton, "btnStart") as CaptionButton;
			_buttonLogin = getUI(CaptionButton, "btnLogin") as CaptionButton;
			_buttonRegister = getUI(CaptionButton, "btnRegister") as CaptionButton;
			_textAnnouncement = getUI(Component, "textAnnouncement") as Component;
			sortChildIndex();
			
			_labelAnnouncementCaption = _textAnnouncement.getUI(Label, "caption") as Label;
			_labelAnnouncementContent = _textAnnouncement.getUI(Label, "content") as Label;
			_textAnnouncement.sortChildIndex();
			
			_buttonStart.scaleX = 3;
			_buttonStart.scaleY = 3;
			_buttonStart.alpha = 0;
			_buttonLogin.x = 1028;
			_buttonLogin.alpha = 0;
			_buttonRegister.x = 1028;
			_buttonRegister.alpha = 0;
			_textAnnouncement.alpha;
			_textAnnouncement.x = -242;
			
			_buttonStart.addEventListener(MouseEvent.CLICK, onButtonStartClick);
			_buttonLogin.addEventListener(MouseEvent.CLICK, onButtonLoginClick);
			_buttonRegister.addEventListener(MouseEvent.CLICK, onButtonRegisterClick);
		}
		
		public function show(): void
		{
			TweenLite.to(_buttonStart, .5, { transformAroundCenter: { scaleX: 1, scaleY: 1, alpha: 1 }, ease: Strong.easeOut, onComplete: showOtherButton });
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .6, {x: -1028, ease: Strong.easeIn, onComplete: callback});
		}
		
		private function showOtherButton(): void
		{
			TweenLite.to(_textAnnouncement, .5, {alpha: 1, x: 0});
			TweenLite.to(_buttonLogin, .5, {alpha: 1, x: 800});
			TweenLite.to(_buttonRegister, .5, {delay: .3, alpha: 1, x: 800});
		}
		
		private function onButtonStartClick(evt: MouseEvent): void
		{
			var _evt: LoginEvent = new LoginEvent(LoginEvent.START_EVENT);
			dispatchEvent(_evt);
		}
		
		private function onButtonLoginClick(evt: MouseEvent): void
		{
			var _evt: LoginEvent = new LoginEvent(LoginEvent.ACCOUNT_EVENT);
			dispatchEvent(_evt);
		}
		
		private function onButtonRegisterClick(evt: MouseEvent): void
		{
			var _evt: LoginEvent = new LoginEvent(LoginEvent.ACCOUNT_EVENT);
			dispatchEvent(_evt);
		}
	}
}