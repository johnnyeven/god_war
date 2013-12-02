package com.xgame.godwar.liteui.component
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.ui.MessageBoxEvent;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UIUtils;
	import com.xgame.godwar.utils.manager.LanguageManager;
	import com.xgame.godwar.utils.manager.PopUpManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	public class MessageBox extends Component
	{
		protected var _labelCaption: Label;
		protected var _labelContent: Label;
		protected var _okButton: CaptionButton;
		protected var _cancelButton: CaptionButton;
		private var _buttonType: uint;
		public static var defaultSkinName: String;
		public static const BUTTON_OK: uint = 1;
		public static const BUTTON_CANCEL: uint = 2;
		
		public function MessageBox(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.MessageBox", null, false) as DisplayObjectContainer);
			_labelCaption = getUI(Label, "title") as Label;
			_labelContent = getUI(Label, "lblContent") as Label;
			_okButton = getUI(CaptionButton, "btnOk") as CaptionButton;
			_cancelButton = getUI(CaptionButton, "btnCancel") as CaptionButton;
			_okButton.caption = LanguageManager.getInstance().lang("common_messagebox_ok");
			_cancelButton.caption = LanguageManager.getInstance().lang("common_messagebox_cancel");
			sortChildIndex();
			
			_labelCaption.wordWrap = false;
			_labelCaption.align = TextFormatAlign.CENTER;
			_labelContent.wordWrap = true;
			_labelContent.align = TextFormatAlign.LEFT;
			
			_okButton.addEventListener(MouseEvent.CLICK, onOkButtonClick);
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClick);
			
			initButton();
		}
		
		override public function dispose(): void
		{
			super.dispose();
			_labelCaption.dispose();
			_labelContent.dispose();
			_okButton.dispose();
			_cancelButton.dispose();
			_labelCaption = null;
			_labelContent = null;
			_okButton = null;
			_cancelButton = null;
		}
		
		private function initButton(): void
		{
			if(_buttonType & BUTTON_OK)
			{
				_okButton.visible = true;
			}
			else
			{
				_okButton.visible = false;
			}
			if(_buttonType & BUTTON_CANCEL)
			{
				_cancelButton.visible = true;
			}
			else
			{
				_cancelButton.visible = false;
			}
		}

		public function get buttonType():uint
		{
			return _buttonType;
		}

		public function set buttonType(value:uint):void
		{
			_buttonType = value;
			initButton();
		}
		
		public function get caption(): String
		{
			return _labelCaption.text;
		}
		
		public function set caption(value: String):void
		{
			_labelCaption.text = value;
		}
		
		public function get content(): String
		{
			return _labelContent.text;
		}
		
		public function set content(value: String):void
		{
			_labelContent.text = value;
		}
		
		protected function onOkButtonClick(evt: MouseEvent): void
		{
			var event: MessageBoxEvent = new MessageBoxEvent(MessageBoxEvent.BTN_OK_CLICK);
			dispatchEvent(event);
			close();
		}
		
		protected function onCancelButtonClick(evt: MouseEvent): void
		{
			var event: MessageBoxEvent = new MessageBoxEvent(MessageBoxEvent.BTN_CANCEL_CLICK);
			dispatchEvent(event);
			close();
		}
		
		public function close(): void
		{
			PopUpManager.removePopUp(this);
			dispatchEvent(new Event(Event.CLOSE));
			dispose();
		}
		
		public static function show(caption: String, content: String, skinName: String = "", mode: Boolean = true, buttonType: uint = 3): MessageBox
		{
			var skin: DisplayObject;
			if(!StringUtils.empty(skinName))
			{
				skin = ResourcePool.instance.getDisplayObject(skinName);
			}
			var _message: MessageBox = new MessageBox(skin as DisplayObjectContainer);
			
			_message.caption = caption;
			_message.content = content;
			_message.buttonType = buttonType;
			UIUtils.center(_message);
			PopUpManager.addPopUp(_message, mode);
			return _message;
		}
	}
}