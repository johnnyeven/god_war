package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.RoleCardParameter;

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
			var _param: RoleCardParameter = _parameter as RoleCardParameter;
			if(_param != null)
			{
				_attack = _param.attack;
				_def = _param.def;
				_mdef = _param.mdef;
				_health = _param.health;
				_healthMax = _param.health;
			}
		}

		public function get attack():int
		{
			return _attack;
		}

		public function get def():int
		{
			return _def;
		}

		public function get mdef():int
		{
			return _mdef;
		}

		public function get health():int
		{
			return _health;
		}

		public function get healthMax():int
		{
			return _healthMax;
		}

		override public function clone():Card
		{
			return new RoleCard(id, displayMode);
		}
	}
}