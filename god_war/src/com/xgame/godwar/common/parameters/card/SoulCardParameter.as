package com.xgame.godwar.common.parameters.card
{
	public class SoulCardParameter extends RoleCardParameter
	{
		public var level: int;
		public var race: int;
		public var skillList: Vector.<String>;
		
		public function SoulCardParameter()
		{
			super();
			skillList = new Vector.<String>();
		}
	}
}