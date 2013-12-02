package com.xgame.godwar.events.ui
{
	import flash.events.Event;
	
	public class MessageBoxEvent extends Event
	{
		public static const BTN_OK_CLICK: String = "MessageBoxEvent.BtnOkClick";
		public static const BTN_NO_CLICK: String = "MessageBoxEvent.BtnNoClick";
		public static const BTN_CANCEL_CLICK: String = "MessageBoxEvent.BtnCancelClick";
		
		public function MessageBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}