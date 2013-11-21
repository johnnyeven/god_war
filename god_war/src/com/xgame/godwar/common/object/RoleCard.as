package com.xgame.godwar.common.object
{
	public class RoleCard extends Card
	{
		private var _attack: int;
		private var _def: int;
		private var _mdef: int;
		private var _health: int;
		private var _healthMax: int;
		
		public function RoleCard(id:String=null)
		{
			super(id);
		}
	}
}