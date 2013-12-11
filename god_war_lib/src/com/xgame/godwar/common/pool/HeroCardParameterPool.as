package com.xgame.godwar.common.pool
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class HeroCardParameterPool extends Object implements IPool
	{
		private var _pool: Dictionary;
		private var _list: Array;
		private static var _instance: HeroCardParameterPool;
		private static var _allowInstance: Boolean = false;
		
		public function HeroCardParameterPool()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_pool = new Dictionary();
			_list = new Array();
		}
		
		public static function get instance(): HeroCardParameterPool
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new HeroCardParameterPool();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function add(key:Object, value:Object, callback:Function=null):void
		{
			_pool[key] = value;
			_list.push(value);
			if(callback != null)
			{
				callback();
			}
		}
		
		public function get(key:Object):Object
		{
			return _pool[key];
		}
		
		public function remove(key:Object):void
		{
			_pool[key] = null;
			delete _pool[key];
			
			var i: int = _list.indexOf(key);
			if(i >= 0)
			{
				_list.splice(i, 1);
			}
		}
		
		public function removeAll():void
		{
			var _key: Object;
			for(_key in _pool)
			{
				remove(_key);
			}
			_pool = new Dictionary();
			
			_list.splice(0, _list.length);
		}
		
		public function contain(key:Object):Boolean
		{
			return _pool.hasOwnProperty(key);
		}

		public function get list():Array
		{
			return _list;
		}

	}
}