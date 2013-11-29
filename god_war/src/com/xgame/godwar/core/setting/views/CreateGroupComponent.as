package com.xgame.godwar.core.setting.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.CardConfigEvent;
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
	
	public class CreateGroupComponent extends Component
	{
		public var lblTitle:Label;
		public var lblName:Label;
		public var iptName:TextField;
		public var btnOk:CaptionButton;
		public var btnCancel:CaptionButton;
		
		public function CreateGroupComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.CreateGroupComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			lblName = getUI(Label, "lblName") as Label;
			btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			btnCancel = getUI(CaptionButton, "btnCancel") as CaptionButton;
			
			sortChildIndex();
			
			iptName = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0xCFC672;
			_textFormat.font = "宋体";
			_textFormat.size = 14;
			iptName.type = TextFieldType.INPUT;
			iptName.defaultTextFormat = _textFormat;
			iptName.text = "";
			iptName.x = 133;
			iptName.y = 102;
			iptName.width = 164;
			iptName.height = 23;
			addChild(iptName);
			
			btnOk.addEventListener(MouseEvent.CLICK, onBtnOkClick);
			btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnOkClick(evt: MouseEvent): void
		{
			if(!StringUtils.empty(iptName.text))
			{
				var event:CardConfigEvent = new CardConfigEvent(CardConfigEvent.CREATE_GROUP_OK_CLICK);
				event.value = iptName.text;
				dispatchEvent(event);
			}
		}
		
		private function onBtnCancelClick(evt: MouseEvent): void
		{
			iptName.text = "";
			
			dispatchEvent(new CardConfigEvent(CardConfigEvent.CREATE_GROUP_CANCEL_CLICK));
		}
		
		public function get groupName(): String
		{
			return iptName.text;
		}
	}
}