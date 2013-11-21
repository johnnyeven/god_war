package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;

	public class SoulCard extends RoleCard
	{
		private var _level: int;
		private var _race: int;
		
		public function SoulCard(id:String=null)
		{
			super(id);
		}
		
		override protected function loadCardInfo():void
		{
			var _param: SoulCardParameter = _parameter as SoulCardParameter;
			if(_param != null)
			{
				_level = _param.level;
				_race = _param.race;
			}
		}
	}
}