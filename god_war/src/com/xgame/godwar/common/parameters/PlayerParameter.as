package com.xgame.godwar.common.parameters
{
	import com.xgame.godwar.utils.Int64;

	public class PlayerParameter extends Object
	{
		public var guid: String;
		public var name: String;
		public var heroCardId: String;
		public var playerStatus: int = int.MIN_VALUE;
		
		public function PlayerParameter()
		{
			super();
		}
	}
}