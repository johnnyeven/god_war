package com.xgame.godwar.common.parameters
{
	public class RoomListItemParameter extends Object
	{
		public var id: int = int.MIN_VALUE;
		public var title: String;
		public var ownerName: String;
		public var peopleCount: int = int.MIN_VALUE;
		public var peopleLimit: int = int.MIN_VALUE;
		
		public function RoomListItemParameter()
		{
			super();
		}
	}
}