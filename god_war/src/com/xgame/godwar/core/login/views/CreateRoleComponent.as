package com.xgame.godwar.core.login.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.StringUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class CreateRoleComponent extends Component
	{
		private var btnBack: Button;
		private var caption: Label;
		private var lblRoleName: Label;
		private var iptRoleName: TextField;
		private var btnEnter: CaptionButton;
		
		public function CreateRoleComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.login.CreateAccountRole", null, false) as DisplayObjectContainer);
			
			btnBack = getUI(Button, "back") as Button;
			caption = getUI(Label, "caption") as Label;
			lblRoleName = getUI(Label, "lblRoleName") as Label;
			btnEnter = getUI(CaptionButton, "btnEnter") as CaptionButton;
			
			btnEnter.addEventListener(MouseEvent.CLICK, onBtnEnterClick);
			
			sortChildIndex();
			
			iptRoleName = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0x00CCFF;
			_textFormat.font = "宋体";
			_textFormat.size = 12;
			iptRoleName.type = TextFieldType.INPUT;
			iptRoleName.defaultTextFormat = _textFormat;
			iptRoleName.text = "";
			iptRoleName.x = 425;
			iptRoleName.y = 363;
			iptRoleName.width = 164;
			iptRoleName.height = 20;
			addChild(iptRoleName);
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