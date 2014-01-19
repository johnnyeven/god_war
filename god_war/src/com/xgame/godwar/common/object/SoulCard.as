package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.room.views.BattleGameCardFormationComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

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
			var formationComponent: BattleGameCardFormationComponent = CardManager.instance.battleGameComponent.panelComponent.cardFormation;
			var bitmapMovie: BitmapMovieDispaly;
			if(formationComponent.soulCard0 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
				formationComponent.card0.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard1 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
				formationComponent.card1.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard2 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
				formationComponent.card2.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard3 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("effect_highlight1", "assets.effect.highlight.Highlight1");
				formationComponent.card3.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			evt.stopImmediatePropagation();
			
			if(!formationComponent.card0.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card0.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card1.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card1.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card2.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card2.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card3.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card3.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
		}
		
		private function onCardFormationClick(evt: MouseEvent): void
		{
			var formationComponent: BattleGameCardFormationComponent = CardManager.instance.battleGameComponent.panelComponent.cardFormation;
			var card: MovieClip = evt.currentTarget as MovieClip;
			card.removeEventListener(MouseEvent.CLICK, onCardFormationClick);
			
			var current: SoulCard = CardManager.instance.currentSelectedCard as SoulCard;
			if(card == formationComponent.card0)
			{
				CardManager.instance.battleGameComponent.panelComponent.removeCard(current);
				formationComponent.setCard(0, current);
			}
			else if(card == formationComponent.card1)
			{
				CardManager.instance.battleGameComponent.panelComponent.removeCard(current);
				formationComponent.setCard(1, current);
			}
			else if(card == formationComponent.card2)
			{
				CardManager.instance.battleGameComponent.panelComponent.removeCard(current);
				formationComponent.setCard(2, current);
			}
			else if(card == formationComponent.card3)
			{
				CardManager.instance.battleGameComponent.panelComponent.removeCard(current);
				formationComponent.setCard(3, current);
			}
			
			if(formationComponent.soulCard0 != null &&
				formationComponent.soulCard1 != null &&
				formationComponent.soulCard2 != null &&
				formationComponent.soulCard3 != null)
			{
				
			}
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
				GameManager.container.addEventListener(MouseEvent.CLICK, onCancelSelect);
			}
			else
			{
				return;
			}
			evt.stopImmediatePropagation();
		}
		
		protected function onCancelSelect(evt: MouseEvent): void
		{
			GameManager.container.removeEventListener(MouseEvent.CLICK, onCancelSelect);
			CardManager.instance.currentSelectedCard = null;
		}
		
//		override public function hideController(): void
//		{
//			
//		}
	}
}