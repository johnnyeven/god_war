package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;

	public class HeroCard extends RoleCard
	{
		private var _nickname: String;
		private var _hit: int;
		private var _flee: int;
		private var _race: int;
		
		public function HeroCard(id:String=null)
		{
			super(id);
		}
		
		override protected function loadCardInfo():void
		{
			super.loadCardInfo();
			var _param: HeroCardParameter = _parameter as HeroCardParameter;
			if(_param != null)
			{
				_nickname = _param.nickname;
				_hit = _param.hit;
				_flee = _param.flee;
				_race = _param.race;
			}
		}

		public function get nickname():String
		{
			return _nickname;
		}

		public function get hit():int
		{
			return _hit;
		}

		public function get flee():int
		{
			return _flee;
		}

		public function get race():int
		{
			return _race;
		}
	}
}