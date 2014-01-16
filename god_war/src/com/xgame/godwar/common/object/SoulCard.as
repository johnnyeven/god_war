package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;

	public class SoulCard extends RoleCard
	{
		private var _level: int;
		private var _race: int;
		
		private var btnFight: Button;
		private var btnAttack: Button;
		private var btnSpell: Button;
		private var btnRest: Button;
		
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
		
		override protected function loadCardController(): void
		{
			btnFight = new Button(ResourcePool.instance.getDisplayObject("assets.ui.card.FightButton", null, false) as DisplayObjectContainer);
			btnAttack = new Button(ResourcePool.instance.getDisplayObject("assets.ui.card.AttackButton", null, false) as DisplayObjectContainer);
			btnSpell = new Button(ResourcePool.instance.getDisplayObject("assets.ui.card.SpellButton", null, false) as DisplayObjectContainer);
			btnRest = new Button(ResourcePool.instance.getDisplayObject("assets.ui.card.RestButton", null, false) as DisplayObjectContainer);
			
			_cardController.addChild(btnFight);
			UIUtils.center(btnFight, this);
			
			_cardController.addChild(btnAttack);
			UIUtils.center(btnAttack, this);
			btnAttack.y -= 40;
			_cardController.addChild(btnSpell);
			UIUtils.center(btnSpell, this);
			_cardController.addChild(btnRest);
			UIUtils.center(btnRest, this);
			btnRest.y += 40;
		}
	}
}