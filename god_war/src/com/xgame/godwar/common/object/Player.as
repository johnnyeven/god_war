package com.xgame.godwar.common.object
{
	import com.xgame.godwar.utils.UInt64;

	public class Player
	{
		private var _guid: String;
		private var _accountId: UInt64;
		private var _name: String;
		private var _level: int;
		private var _avatarId: String;
		private var _cash: UInt64;
		private var _winningCount: int; //胜利场次
		private var _battleCount: int; //总战斗场次
		private var _honor: int; //荣誉称号
		
		public function Player()
		{
		}

		public function get accountId():UInt64
		{
			return _accountId;
		}

		public function get name():String
		{
			return _name;
		}

		public function get level():int
		{
			return _level;
		}

		public function get avatarId():String
		{
			return _avatarId;
		}

		public function get cash():UInt64
		{
			return _cash;
		}

		public function get winningCount():int
		{
			return _winningCount;
		}

		public function get battleCount():int
		{
			return _battleCount;
		}

		public function get honor():int
		{
			return _honor;
		}

		public function get winningRate(): Number
		{
			return Number((_winningCount / _battleCount).toFixed(2));
		}

		public function set accountId(value:UInt64):void
		{
			_accountId = value;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function set avatarId(value:String):void
		{
			_avatarId = value;
		}

		public function set cash(value:UInt64):void
		{
			_cash = value;
		}

		public function set winningCount(value:int):void
		{
			_winningCount = value;
		}

		public function set battleCount(value:int):void
		{
			_battleCount = value;
		}

		public function set honor(value:int):void
		{
			_honor = value;
		}

		public function get guid():String
		{
			return _guid;
		}

		public function set guid(value:String):void
		{
			_guid = value;
		}


	}
}