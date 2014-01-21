package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.room.views.BattleGameCardFormationComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.events.CardEvent;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class SoulCard extends RoleCard
	{
		private var _level: int;
		private var _race: int;
		private var _isBack: Boolean = true;	//暗置状态
		
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
			btnFight.x = (cardResourceBuffer.width - btnFight.width) / 2;
			btnFight.y = (cardResourceBuffer.height - btnFight.height) / 2;
			
			_cardController.addChild(btnAttack);
			btnAttack.x = (cardResourceBuffer.width - btnAttack.width) / 2;
			btnAttack.y = (cardResourceBuffer.height - btnAttack.height) / 2 - 35;
			_cardController.addChild(btnSpell);
			btnSpell.x = (cardResourceBuffer.width - btnSpell.width) / 2;
			btnSpell.y = (cardResourceBuffer.height - btnSpell.height) / 2;
			_cardController.addChild(btnRest);
			btnRest.x = (cardResourceBuffer.width - btnRest.width) / 2;
			btnRest.y = (cardResourceBuffer.height - btnRest.height) / 2 + 35;
			
			btnFight.addEventListener(MouseEvent.CLICK, onBtnFightClick);
		}
		
		private function onBtnFightClick(evt: MouseEvent): void
		{
			var event: CardEvent = new CardEvent(CardEvent.FIGHT_CLICK, true);
			event.value = this;
			dispatchEvent(event);
			evt.stopImmediatePropagation();
		}
		
		override protected function onMouseClick(evt: MouseEvent): void
		{
			if(enabled && _inRound)
			{
				if(_inHand)
				{
					btnFight.visible = true;
					btnAttack.visible = false;
					btnSpell.visible = false;
					btnRest.visible = false;
				}
				else if(_inGame)
				{
					btnFight.visible = false;
					btnAttack.visible = true;
					btnSpell.visible = true;
					btnRest.visible = true;
				}
				else
				{
					return;
				}
				
				CardManager.instance.currentSelectedCard = this;
				GameManager.container.addEventListener(MouseEvent.CLICK, cancelSelect);
			}
			else
			{
				return;
			}
			evt.stopPropagation();
		}
		
		public function cancelSelect(evt: MouseEvent = null): void
		{
			GameManager.container.removeEventListener(MouseEvent.CLICK, cancelSelect);
			CardManager.instance.currentSelectedCard = null;
			CardManager.instance.currentFightCard = null;
		}

		public function get isBack():Boolean
		{
			return _isBack;
		}

	}
}