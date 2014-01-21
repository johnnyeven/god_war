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
		private var _avatarNormalPath: String;
		private var _avatarBigPath: String;
		private var _cash: UInt64;
		private var _winningCount: int; //胜利场次
		private var _battleCount: int; //总战斗场次
		private var _honor: int; //荣誉称号
		private var _group: int; //1=红队 2=蓝队
		private var _heroCardId: String = "";
		private var _heroCardPath: String = "";
		private var _isOwner: Boolean = false;
		private var _ready: Boolean = false;
		private var _soulCardList: Vector.<SoulCard>;
//		private var _supplyCardList: Vector.<SupplyCard>;
		private var _cardHandList: Vector.<Card>;
		private var _cardGraveList: Vector.<Card>;
		
		public var soulCardCount: int;
		public var supplyCardCount: int;
		
		public function Player()
		{
			_soulCardList = new Vector.<SoulCard>();
			_cardHandList = new Vector.<Card>();
		}
		
		public function addSoulCard(card: SoulCard): void
		{
			_soulCardList.push(card);
		}
		
		public function removeSoulCard(card: SoulCard): Boolean
		{
			var i: int = _soulCardList.indexOf(card);
			if(i >= 0)
			{
				_soulCardList.splice(i, 1);
				return true;
			}
			return false;
		}
		
		public function addCardHand(card: Card): void
		{
			_cardHandList.push(card);
		}
		
		public function removeHandCard(card: SoulCard): Boolean
		{
			var i: int = _cardHandList.indexOf(card);
			if(i >= 0)
			{
				_cardHandList.splice(i, 1);
				return true;
			}
			return false;
		}
		
		public function addCardGrave(card: Card): void
		{
			_cardGraveList.push(card);
		}
		
		public function removeGraveCard(card: SoulCard): Boolean
		{
			var i: int = _cardGraveList.indexOf(card);
			if(i >= 0)
			{
				_cardGraveList.splice(i, 1);
				return true;
			}
			return false;
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
			if(_battleCount > 0)
			{
				return Number((_winningCount / _battleCount).toFixed(2));
			}
			else
			{
				return 0;
			}
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

		public function get group():int
		{
			return _group;
		}

		public function set group(value:int):void
		{
			_group = value;
		}

		public function get avatarNormalPath():String
		{
			return _avatarNormalPath;
		}

		public function set avatarNormalPath(value:String):void
		{
			_avatarNormalPath = value;
		}

		public function get avatarBigPath():String
		{
			return _avatarBigPath;
		}

		public function set avatarBigPath(value:String):void
		{
			_avatarBigPath = value;
		}

		public function get isOwner():Boolean
		{
			return _isOwner;
		}

		public function set isOwner(value:Boolean):void
		{
			_isOwner = value;
		}

		public function get ready():Boolean
		{
			return _ready;
		}

		public function set ready(value:Boolean):void
		{
			_ready = value;
		}

		public function get heroCardId():String
		{
			return _heroCardId;
		}

		public function set heroCardId(value:String):void
		{
			_heroCardId = value;
		}

		public function get heroCardPath():String
		{
			return _heroCardPath;
		}

		public function set heroCardPath(value:String):void
		{
			_heroCardPath = value;
		}

		public function get soulCardList():Vector.<SoulCard>
		{
			return _soulCardList;
		}

		public function get cardHandList():Vector.<Card>
		{
			return _cardHandList;
		}
		
		public function get cardGraveList():Vector.<Card>
		{
			return _cardGraveList;
		}


	}
}