package com.xgame.godwar.common.object
{
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	
	import flash.errors.IllegalOperationError;

	public class CardManager
	{
		private static var _instance: CardManager = null;
		private static var _allowInstance: Boolean = false;
		
		private var _currentSelectedCard: Card;
		private var _currentFightCard: SoulCard;
		private var _currentSelectedSkill: Skill;
		
		public function CardManager()
		{
			if(_allowInstance)
			{
				
			}
			else
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public static function get instance(): CardManager
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new CardManager();
				_allowInstance = false;
			}
			
			return _instance;
		}

		public function get currentSelectedCard():Card
		{
			return _currentSelectedCard;
		}

		public function set currentSelectedCard(value:Card):void
		{
			if(_currentSelectedCard != null)
			{
				_currentSelectedCard.hideController();
			}
			_currentSelectedCard = value;
			
			if(_currentSelectedCard != null)
			{
				_currentSelectedCard.showController();
			}
		}

		public function get currentFightCard(): SoulCard
		{
			return _currentFightCard;
		}

		public function set currentFightCard(value: SoulCard):void
		{
			_currentFightCard = value;
		}

		public function get currentSelectedSkill():Skill
		{
			return _currentSelectedSkill;
		}

		public function set currentSelectedSkill(value:Skill):void
		{
			_currentSelectedSkill = value;
		}


	}
}