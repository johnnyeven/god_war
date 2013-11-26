package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;

	public class SoulCard extends RoleCard
	{
		private var _level: int;
		private var _race: int;
		
		public function SoulCard(id:String=null, displayMode: int = 0)
		{
			super(id, displayMode);
		}
		
		override protected function loadCardInfo():void
		{
			super.loadCardInfo();
			var _param: SoulCardParameter = _parameter as SoulCardParameter;
			if(_param != null)
			{
				_level = _param.level;
				_race = _param.race;
			}
		}

		public function get level():int
		{
			return _level;
		}

		public function get race():int
		{
			return _race;
		}
		
		override public function clone():Card
		{
			return new SoulCard(id, displayMode);
		}
	}
}