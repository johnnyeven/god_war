package com.xgame.godwar.common.parameters
{
	import com.xgame.godwar.utils.UInt64;

	public class PlayerParameter extends Object
	{
		public var guid: String;
		public var accountId: UInt64;
		public var name: String;
		public var level: int = int.MIN_VALUE;
		public var avatarId: String;
		public var heroCardId: String;
		public var cash: UInt64;
		public var winningCount: int = int.MIN_VALUE;
		public var battleCount: int = int.MIN_VALUE;
		public var honor: int = int.MIN_VALUE;
		public var playerStatus: int = int.MIN_VALUE;
		public var group: int = int.MIN_VALUE;
		
		public function PlayerParameter()
		{
			super();
		}
	}
}