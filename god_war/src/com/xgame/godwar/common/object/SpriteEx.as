package com.xgame.godwar.common.object
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class SpriteEx extends Sprite
	{
		private var _eventListener: Dictionary;
		
		public function SpriteEx()
		{
			super();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if(_eventListener == null)
			{
				_eventListener = new Dictionary();
			}
			
			var _listener: Vector.<Function>;
			if(_eventListener[type] != null)
			{
				_listener = _eventListener[type] as Vector.<Function>;
				var _index: int = _listener.indexOf(listener);
				if(_index == -1)
				{
					_listener.push(listener);
				}
				else
				{
					_listener[_index] = listener;
				}
				_eventListener[type] = _listener;
			}
			else
			{
				_listener = new Vector.<Function>();
				_listener.push(listener);
				_eventListener[type] = _listener;
			}
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			
			if(_eventListener == null)
			{
				return;
			}
			
			var _listener: Vector.<Function>;
			if(_eventListener[type] != null)
			{
				_listener = _eventListener[type] as Vector.<Function>;
				var _index: int = _listener.indexOf(listener);
				if(_index > 0)
				{
					_listener.splice(_index, 1);
				}
				_eventListener[type] = _listener;
			}
		}
		
		public function removeEventListeners(): void
		{
			if(_eventListener != null)
			{
				for(var type: String in _eventListener)
				{
					removeEventListenerType(type);
				}
				_eventListener = null;
			}
		}
		
		public function removeEventListenerType(type: String): void
		{
			var _listener: Vector.<Function> = _eventListener[type] as Vector.<Function>;
			
			for(var i:uint = 0; i < _listener.length; i++)
			{
				removeEventListener(type, _listener[i]);
			}
		}
	}
}