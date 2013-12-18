package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.FlowLayout;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class BattleGameChatComponent extends Component
	{
		private var chatContainer: Container;
		private var chatScroll: ScrollBar;
		private var btnSend: CaptionButton;
		private var iptChat: TextField;
		
		public function BattleGameChatComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameChatComponent", null, false) as DisplayObjectContainer);
			
			chatContainer = getUI(Container, "chatContainer") as Container;
			chatScroll = getUI(ScrollBar, "chatScroll") as ScrollBar;
			btnSend = getUI(CaptionButton, "btnSend") as CaptionButton;
			
			sortChildIndex();
			
			iptChat = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0xCFC672;
			_textFormat.font = "宋体";
			_textFormat.size = 12;
			iptChat.type = TextFieldType.INPUT;
			iptChat.defaultTextFormat = _textFormat;
			iptChat.text = "";
			iptChat.x = 23;
			iptChat.y = 283;
			iptChat.width = 137;
			iptChat.height = 19;
			addChild(iptChat);
			
			chatContainer.layout = new FlowLayout(chatContainer);
			chatContainer.layout.hGap = 3;
			chatContainer.layout.vGap = 3;
			chatScroll.orientation = ScrollBarOrientation.VERTICAL;
			chatScroll.view = chatContainer;
		}
	}
}