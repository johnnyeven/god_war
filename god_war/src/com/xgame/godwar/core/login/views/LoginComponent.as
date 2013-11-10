package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.LoginEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class LoginComponent extends Component
	{
		private var btnLogin: CaptionButton;
		private var btnBack: CaptionButton;
		private var lblAccount: Label;
		private var lblPassword: Label;
		private var iptAccount: TextField;
		private var iptPassword: TextField;
		
		public function LoginComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.LoginComponent", null, false) as DisplayObjectContainer);
			btnLogin = getUI(CaptionButton, "btnLogin") as CaptionButton;
			btnBack = getUI(CaptionButton, "btnBack") as CaptionButton;
			lblAccount = getUI(Label, "lblAccount") as Label;
			lblPassword = getUI(Label, "lblPassword") as Label;
			
			btnLogin.addEventListener(MouseEvent.CLICK, onBtnLoginClick);
			btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
			
			sortChildIndex();
			
			iptAccount = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0x000000;
			_textFormat.font = "宋体";
			_textFormat.size = 18;
			iptAccount.type = TextFieldType.INPUT;
			iptAccount.defaultTextFormat = _textFormat;
			iptAccount.text = "";
			iptAccount.x = 430;
			iptAccount.y = 254;
			iptAccount.width = 234;
			iptAccount.height = 28;
			addChild(iptAccount);
			
			
			iptPassword = new TextField();
			_textFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0x000000;
			_textFormat.font = "宋体";
			_textFormat.size = 18;
			iptPassword.type = TextFieldType.INPUT;
			iptPassword.defaultTextFormat = _textFormat;
			iptPassword.text = "";
			iptPassword.x = 430;
			iptPassword.y = 326;
			iptPassword.width = 234;
			iptPassword.height = 28;
			addChild(iptPassword);
		}
		
		private function onBtnLoginClick(evt: MouseEvent): void
		{
			dispatchEvent(new LoginEvent(LoginEvent.LOGIN_CLICK_EVENT));
		}
		
		private function onBtnBackClick(evt: MouseEvent): void
		{
			dispatchEvent(new LoginEvent(LoginEvent.LOGIN_BACK_EVENT));
		}
		
		public function get userName(): String
		{
			return iptAccount.text;
		}
		
		public function get userPass(): String
		{
			return iptPassword.text;
		}
	}
}