package com.xgame.godwar.core.scene
{
	import com.xgame.godwar.display.BitmapDisplay;
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.events.scene.SceneEvent;
	import com.xgame.godwar.ns.NSCamera;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	public class Scene implements IEventDispatcher
	{
		protected var _objectList: Array;
		protected var _renderList: Array;
		protected var _mapGround: Shape;
		protected var _stage: Stage;
		protected var _initialized: Boolean = false;
		protected var _ready: Boolean = false;
		protected var _container: DisplayObjectContainer;
		protected var _layerDisplay: Sprite;
		protected var _layerEffect: Sprite;
		private var _lastZSortTime: uint;
		private var _currentRenderIndex: uint = 0;
		private var _eventDispatcher: EventDispatcher;
		private static const ZSORT_DELAY: uint = 1000;
		private static const RENDER_MAX_TIME: uint = 15;
		private static var _instance: Scene;
		private static var _allowInstance: Boolean = false;
		
		public function Scene(stage: Stage, container: DisplayObjectContainer = null)
		{
			if(_allowInstance)
			{
				if(stage == null)
				{
					throw new IllegalOperationError("stage参数必须指定舞台");
				}
				_stage = stage;
				_container = container == null ? stage : container;
				_eventDispatcher = new EventDispatcher(this);
				
				_objectList = new Array();
				_renderList = new Array();
				
				_layerDisplay = new Sprite();
				_layerEffect = new Sprite();
				_container.addChild(_layerDisplay);
				_container.addChild(_layerEffect);
				
				initializeBuffer();
				_initialized = true;
			}
			else
			{
				throw new IllegalOperationError("不允许实例化这个类");
			}
		}
		
		public static function initialization(stage: Stage, container: DisplayObjectContainer = null): Scene
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Scene(stage, container);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): Scene
		{
			return _instance;
		}
		
		public function initializeBuffer(): void
		{
			_mapGround = new Shape();
		}
		
		public function addObject(value: BitmapDisplay): void
		{
			if(_objectList.indexOf(value) > -1)
			{
				return;
			}
			_objectList.push(value);
			_layerDisplay.addChild(value);
			value.NSCamera::inScene = true;
			value.NSCamera::shadeIn();
		}
		
		public function removeObject(value: BitmapDisplay): void
		{
			var index: int = _objectList.indexOf(value);
			if(index > -1)
			{
				_objectList.splice(index, 1);
			}
			
			if(_layerDisplay.contains(value))
			{
				_layerDisplay.removeChild(value);
				value.NSCamera::inScene = false;
				value.NSCamera::shadeOut();
			}
			value.dispose();
			value = null;
		}
		
		public function getDisplay(value: uint): BitmapDisplay
		{
			if(value >= _objectList.length)
			{
				return null;
			}
			return _objectList[value] as BitmapDisplay;
		}
		
		public function getDisplayByGuid(value: String): BitmapDisplay
		{
			var display: BitmapDisplay;
			for each(display in _objectList)
			{
				if(display.guid == value)
				{
					return display;
				}
			}
			return null;
		}
		
		public function get objectList(): Array
		{
			return _objectList;
		}
		
		public function get renderList():Array
		{
			return _renderList;
		}
		
		public function get stage(): Stage
		{
			return _stage;
		}
		
		public function get initialized(): Boolean
		{
			return _initialized;
		}
		
		public function get ready():Boolean
		{
			return _ready;
		}
		
		public function get container(): DisplayObjectContainer
		{
			return _container;
		}
		
		protected function updateTimer(): void
		{
			GlobalContextConfig.Timer = getTimer();
		}
		
		public function dispose(): void
		{
			_objectList.splice(0, _objectList.length);
			
			while(_layerDisplay.numChildren > 0)
			{
				_layerDisplay.removeChildAt(0);
			}
			while(_layerEffect.numChildren > 0)
			{
				_layerEffect.removeChildAt(0);
			}
			while(_container.numChildren > 0)
			{
				_container.removeChildAt(0);
			}
			
			_mapGround.graphics.clear();
			_mapGround = null;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

	}
}