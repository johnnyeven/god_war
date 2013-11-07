package com.xgame.godwar.core.hall.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.CreateBattleRoomEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.Select;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class CreateBattleRoomComponent extends Component
	{
		private var btnOk: CaptionButton;
		private var btnCancel: CaptionButton;
		private var lblTitle: Label;
		private var lblCount: Label;
		private var inputTitle: TextField;
		private var selectCount: Select;
		
		public function CreateBattleRoomComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.hall.CreateBattleRoomComponent", null, false) as DisplayObjectContainer);
			
			btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			btnCancel = getUI(CaptionButton, "btnCancel") as CaptionButton;
			lblTitle = getUI(Label, "lblTitle") as Label;
			lblCount = getUI(Label, "lblCount") as Label;
			
			sortChildIndex();
			
			inputTitle = new TextField();
			var _textFormat: TextFormat = new TextFormat();
			_textFormat.align = TextFieldAutoSize.LEFT;
			_textFormat.color = 0xCFC672;
			_textFormat.font = "宋体";
			_textFormat.size = 16;
			inputTitle.type = TextFieldType.INPUT;
			inputTitle.defaultTextFormat = _textFormat;
			inputTitle.text = "";
			inputTitle.x = 35;
			inputTitle.y = 122;
			inputTitle.width = 186;
			inputTitle.height = 36;
			addChild(inputTitle);
			
			selectCount = new Select();
			selectCount.x = 27
			selectCount.y = 197;
			addChild(selectCount);
			
			btnOk.addEventListener(MouseEvent.CLICK, onBtnOkClick);
			btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnOkClick(evt: MouseEvent): void
		{
			dispatchEvent(new CreateBattleRoomEvent(CreateBattleRoomEvent.OK_CLICK));
		}
		
		private function onBtnCancelClick(evt: MouseEvent): void
		{
			dispatchEvent(new CreateBattleRoomEvent(CreateBattleRoomEvent.CANCEL_CLICK));
		}

		public function get title(): String
		{
			return inputTitle.text;
		}
		
		public function get count(): int
		{
			if(selectCount.value != null)
			{
				return int(selectCount.value);
			}
			return 0;
		}

	}
}