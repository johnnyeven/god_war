package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.LoginEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class StartComponent extends Component
	{
		private var _buttonStart: CaptionButton;
		private var _buttonLogin: CaptionButton;
		private var _buttonRegister: CaptionButton;
		
		public function StartComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.StartComponent", null, false) as DisplayObjectContainer);
			_buttonStart = getUI(CaptionButton, "btnStart") as CaptionButton;
			_buttonLogin = getUI(CaptionButton, "btnLogin") as CaptionButton;
			_buttonRegister = getUI(CaptionButton, "btnRegister") as CaptionButton;
			sortChildIndex();
			
			_buttonStart.addEventListener(MouseEvent.CLICK, onButtonStartClick);
			_buttonLogin.addEventListener(MouseEvent.CLICK, onButtonLoginClick);
			_buttonRegister.addEventListener(MouseEvent.CLICK, onButtonRegisterClick);
		}
		
		public function show(): void
		{
			_buttonStart.scaleX = 2;
			_buttonStart.scaleY = 2;
			_buttonStart.alpha = 0;
			TweenLite.to(_buttonStart, .5, { transformAroundCenter: { scaleX: 1, scaleY: 1, alpha: 1 }, ease: Strong.easeOut, onComplete: null });
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