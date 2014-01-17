package com.xgame.godwar.core.center
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.utils.LoaderUtils;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class ResourceCenter extends BaseCenter
	{
		private var _showProgressBarIndex: Dictionary;
		private var _progressBarTitle: Dictionary;
		private var _paramIndex: Dictionary;
		private static var _instance: ResourceCenter;
		private static var _allowInstance: Boolean = false;
		
		public function ResourceCenter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			
			_paramIndex = new Dictionary();
		}
		
		public static function get instance(): ResourceCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new ResourceCenter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function load(
							name: String,
							vars: Object = null,
							onComplete: Function = null,
							onProgress: Function = null,
							onError: Function = null
		): void
		{
			if(onComplete != null)
			{
				addTrigger(name + "_complete", onComplete);
			}
			if(onProgress != null)
			{
				addTrigger(name + "_progress", onProgress);
			}
			if(onError != null)
			{
				addTrigger(name + "_error", onError);
			}
			var _item: LoaderCore = LoaderMax.getLoader(name);
			if(_item == null)
			{
				_item = LoaderUtils.generateLoader(name);
				if(_item != null)
				{
					_item.autoDispose = true;
					_item.name = name;
				}
				else
				{
					return;
				}
			}
			
			if(vars != null)
			{
				if(_paramIndex[name] == null)
				{
					_paramIndex[name] = new Array();
				}
				_paramIndex[name].push(vars);
			}
			
			_item.addEventListener(LoaderEvent.COMPLETE, onLoadComplete);
			_item.addEventListener(LoaderEvent.PROGRESS, onLoadProgress);
			_item.addEventListener(LoaderEvent.IO_ERROR, onLoadIOError);
			_item.load();
		}
		
		private function onLoadComplete(evt: LoaderEvent): void
		{
			var _item: LoaderCore = evt.target as LoaderCore;
			var _name: String = _item.name;
			riseTrigger(_name + "_complete", evt);
			removeTrigger(_name + "_complete", onLoadComplete);
			removeTrigger(_name + "_progress", onLoadProgress);
			removeTrigger(_name + "_error", onLoadIOError);
		}
		
		private function onLoadProgress(evt: LoaderEvent): void
		{
			var _item: LoaderCore = evt.target as LoaderCore;
			var _name: String = _item.name;
			riseTrigger(_name + "_progress", evt);
			//TODO onProgress
		}
		
		private function onLoadIOError(evt: LoaderEvent): void
		{
			var _item: LoaderCore = evt.target as LoaderCore;
			var _name: String = _item.name;
			riseTrigger(_name + "_error", evt);
			removeTrigger(_name + "_complete", onLoadComplete);
			removeTrigger(_name + "_progress", onLoadProgress);
			removeTrigger(_name + "_error", onLoadIOError);
		}
		
		override protected function riseTrigger(key:Object, param:Object=null):void
		{
			var _evt: LoaderEvent = param as LoaderEvent;
			if(_evt == null)
			{
				return;
			}
			var _loader: LoaderCore = _evt.currentTarget as LoaderCore;
			if(_loader == null)
			{
				return;
			}
			var vars: Array = _paramIndex[_loader.name];
			var _item: Array = trigger[key] as Array;
			if(_item == null)
			{
				return;
			}
			
			var func: Function;
			for(var i: int = 0; i<_item.length; i++)
			{
				func = _item[i];
				if(vars != null && i < vars.length)
				{
					_loader.vars.vars = vars[i];
				}
				if(_evt != null)
				{
					func(_evt);
				}
				else
				{
					func();
				}
			}
		}
	}
}