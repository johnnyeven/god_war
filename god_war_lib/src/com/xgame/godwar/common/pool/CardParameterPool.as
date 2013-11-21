package com.xgame.godwar.common.pool
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class CardParameterPool extends Object implements IPool
	{
		private var _pool: Dictionary;
		private static var _instance: CardParameterPool;
		private static var _allowInstance: Boolean = false;
		
		public function CardParameterPool()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_pool = new Dictionary();
		}
		
		public static function get instance(): CardParameterPool
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new CardParameterPool();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function add(key:Object, value:Object, callback:Function=null):void
		{
			_pool[key] = value;
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
		}
		
		public function removeAll():void
		{
			var _key: Object;
			for(_key in _pool)
			{
				remove(_key);
			}
			_pool = new Dictionary();
		}
		
		public function contain(key:Object):Boolean
		{
			return _pool.hasOwnProperty(key);
		}
	}
}