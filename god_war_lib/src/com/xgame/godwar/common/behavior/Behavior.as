package com.xgame.godwar.common.behavior
{
	import com.xgame.godwar.display.BitmapDisplay;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public class Behavior implements IEventDispatcher
	{
		protected var _endPoint: Point;
		protected var _nextPoint: Point;
		protected var _target: BitmapDisplay;
		protected var _listenerInstalled: Boolean = false;
		protected var _eventDispatcher: EventDispatcher;
		
		public function Behavior()
		{
			_eventDispatcher = new EventDispatcher(this);
		}

		public function step(): void
		{
			calculatePosition();
		}
		
		protected function calculatePosition(): void
		{
			_target.x = 0;
			_target.y = 0;
		}
		
		public function installListener(): void
		{
			
		}
		
		public function uninstallListener(): void
		{
			
		}
		
		public function dispose(): void
		{
			uninstallListener();
		}

		public function get target():BitmapDisplay
		{
			return _target;
		}

		public function set target(value:BitmapDisplay):void
		{
			_target = value;
		}

		public function get nextPoint():Point
		{
			return _nextPoint;
		}

		public function get endPoint():Point
		{
			return _endPoint;
		}

		public function get listenerInstalled():Boolean
		{
			return _listenerInstalled;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false): void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(e:Event): Boolean
		{
			return _eventDispatcher.dispatchEvent(e);
		}
		
		public function hasEventListener(type:String): Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false): void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String): Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}