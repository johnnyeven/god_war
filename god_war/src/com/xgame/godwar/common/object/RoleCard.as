package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;

	public class RoleCard extends Card
	{
		private var _attack: int;
		private var _def: int;
		private var _mdef: int;
		private var _health: int;
		private var _healthMax: int;
		
		public function RoleCard(id:String=null, displayMode: int = 0)
		{
			super(id, displayMode);
		}
		
		override protected function loadCardInfo():void
		{
			super.loadCardInfo();
			var _param: SoulCardParameter = _parameter as SoulCardParameter;
			if(_param != null)
			{
				_attack = _param.attack;
				_def = _param.def;
				_mdef = _param.mdef;
				_health = _param.health;
				_healthMax = _param.health;
			}
		}
	}
}