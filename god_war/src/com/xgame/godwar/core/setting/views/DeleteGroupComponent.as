package com.xgame.godwar.core.setting.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.events.CardConfigEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class DeleteGroupComponent extends Component
	{
		public var lblTitle:Label;
		public var lblContent:Label;
		public var btnOk:CaptionButton;
		public var btnCancel:CaptionButton;
		
		public function DeleteGroupComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.config.DeleteGroupComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			lblContent = getUI(Label, "lblContent") as Label;
			btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			btnCancel = getUI(CaptionButton, "btnCancel") as CaptionButton;
			
			sortChildIndex();
			
			btnOk.addEventListener(MouseEvent.CLICK, onBtnOkClick);
			btnCancel.addEventListener(MouseEvent.CLICK, onBtnCancelClick);
		}
		
		private function onBtnOkClick(evt: MouseEvent): void
		{
			var event:CardConfigEvent = new CardConfigEvent(CardConfigEvent.DELETE_GROUP_OK_CLICK);
			dispatchEvent(event);
		}
		
		private function onBtnCancelClick(evt: MouseEvent): void
		{
			dispatchEvent(new CardConfigEvent(CardConfigEvent.DELETE_GROUP_CANCEL_CLICK));
		}
	}
}