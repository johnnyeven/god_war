package com.xgame.godwar.common.object
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.room.views.BattleGameCardFormationComponent;
	import com.xgame.godwar.core.room.views.SoulCardSkillComponent;
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
		private var _skillList: Vector.<SoulCardSkillComponent>;
		private var _currentSkill: String;
		
		private var btnFight: Button;
		private var btnAttack: Button;
		private var btnSpell: Button;
		private var btnRest: Button;
		
		public function SoulCard(id:String=null, displayMode: int = 0)
		{
			super(id, displayMode);
			_skillList = new Vector.<SoulCardSkillComponent>();
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
			var _param: SoulCardParameter = _parameter as SoulCardParameter;
			if(_param != null)
			{
				var skill: Skill;
				var component: SoulCardSkillComponent;
				var offset: int = _scrollRect.height / (_param.skillList.length + 1);
				var startY: int = offset;
				for(var i: int = 0; i < _param.skillList.length; i++)
				{
					skill = new Skill(_param.skillList[i]);
					component = new SoulCardSkillComponent();
					component.card = this;
					component.skill = skill;
					_skillList.push(component);
					_cardController.addChild(component);
					component.x = _scrollRect.width / 2;
					component.y = startY;
					component.visible = false;
					component.addEventListener(MouseEvent.CLICK, onSkillClick);
					startY += offset;
				}
			}
			
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
			btnAttack.addEventListener(MouseEvent.CLICK, onBtnAttackClick);
			btnSpell.addEventListener(MouseEvent.CLICK, onBtnSpellClick);
		}
		
		private function onSkillClick(evt: MouseEvent): void
		{
			var component: SoulCardSkillComponent = evt.currentTarget as SoulCardSkillComponent;
			_currentSkill = component.skill.id;
			evt.stopImmediatePropagation();
			var event: CardEvent = new CardEvent(CardEvent.SPELL_CLICK, true);
			event.value = component;
			dispatchEvent(event);
		}
		
		private function onBtnFightClick(evt: MouseEvent): void
		{
			evt.stopImmediatePropagation();
			var event: CardEvent = new CardEvent(CardEvent.FIGHT_CLICK, true);
			event.value = this;
			dispatchEvent(event);
		}
		
		private function onBtnAttackClick(evt: MouseEvent): void
		{
			evt.stopImmediatePropagation();
			var event: CardEvent = new CardEvent(CardEvent.ATTACK_CLICK, true);
			event.value = this;
			dispatchEvent(event);
		}
		
		private function onBtnSpellClick(evt: MouseEvent): void
		{
			evt.stopImmediatePropagation();
			TweenLite.to(_cardController, .5, {x: _scrollRect.width, ease: Strong.easeOut, onComplete: function(): void
			{
				_cardController.x = -_scrollRect.width;
				var component: SoulCardSkillComponent;
				for(var i: int = 0; i<_skillList.length; i++)
				{
					component = _skillList[i];
					component.visible = true;
				}
				btnFight.visible = false;
				btnAttack.visible = false;
				btnSpell.visible = false;
				btnRest.visible = false;
				
				TweenLite.to(_cardController, .5, {x: 0, ease: Strong.easeOut});
			}});
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
			
			var component: SoulCardSkillComponent;
			for(var i: int = 0; i<_skillList.length; i++)
			{
				component = _skillList[i];
				component.visible = false;
			}
			CardManager.instance.currentSelectedCard = null;
			CardManager.instance.currentFightCard = null;
		}

		public function get isBack():Boolean
		{
			return _isBack;
		}

		public function get currentSkill():String
		{
			return _currentSkill;
		}

		public function get skillList():Vector.<SoulCardSkillComponent>
		{
			return _skillList;
		}


	}
}