package com.xgame.godwar.core.login.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	import com.xgame.godwar.events.LoginEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class CreateRoleComponent extends Component
	{
		private var btnBack: Button;
		private var iptRoleName: TextField;
		private var btnEnter: CaptionButton;
		private var btnDice: Button;
		private var bottomBg: MovieClip;
		private var btnPrev: Button;
		private var btnNext: Button;
		
		public function CreateRoleComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.CreateRoleComponent", null, false) as DisplayObjectContainer);
			
			btnBack = getUI(Button, "btnBack") as Button;
			btnEnter = getUI(CaptionButton, "btnEnter") as CaptionButton;
			btnDice = getUI(Button, "btnDice") as Button;
			bottomBg = getSkin("bottomBg") as MovieClip;
			btnPrev = getUI(Button, "btnPrev") as Button;
			btnNext = getUI(Button, "btnNext") as Button;
			
			btnEnter.addEventListener(MouseEvent.CLICK, onBtnEnterClick);
			
			sortChildIndex();
			
			iptRoleName = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0x000000;
			_textFormat.font = "宋体";
			_textFormat.size = 22;
			iptRoleName.type = TextFieldType.INPUT;
			iptRoleName.defaultTextFormat = _textFormat;
			iptRoleName.text = "";
			iptRoleName.x = 380;
			iptRoleName.y = 430;
			iptRoleName.width = 206;
			iptRoleName.height = 36;
			addChild(iptRoleName);
			
			bottomBg.y = 600;
			btnEnter.scaleX = 3;
			btnEnter.scaleY = 3;
			btnEnter.alpha = 0;
			
			btnBack.x = -btnBack.width;
			btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
		}
		
		public function show(callback: Function = null): void
		{
			TweenLite.to(bottomBg, .5, {y: 490, ease: Strong.easeIn});
			TweenLite.to(btnEnter, .5, {delay: .5, transformAroundCenter: { scaleX: 1, scaleY: 1, alpha: 1 }, ease: Strong.easeOut});
			TweenLite.to(btnBack, .5, {delay: .8, x: 13, ease: Strong.easeOut, onComplete: callback});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .6, {x: -1028, ease: Strong.easeIn, onComplete: callback});
		}
		
		private function onBtnBackClick(evt: MouseEvent): void
		{
			dispatchEvent(new LoginEvent(LoginEvent.CREATEROLE_BACK_EVENT));
		}
		
		private function onBtnEnterClick(evt: MouseEvent): void
		{
			if(!StringUtils.empty(iptRoleName.text))
			{
				ApplicationFacade.getInstance().sendNotification(CreateRoleMediator.SEND_CREATE_ROLE_NOTE, iptRoleName.text);
			}
		}
	}
}