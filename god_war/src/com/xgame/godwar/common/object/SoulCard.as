package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.room.views.BattleGameCardFormationComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.liteui.component.Button;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
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
			}
			else
			{
				return;
			}
		}
		
//		override public function hideController(): void
//		{
//			
//		}
	}
}