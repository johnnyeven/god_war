package com.xgame.godwar.common.object
{
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	
	import flash.errors.IllegalOperationError;

	public class CardManager
	{
		private static var _instance: CardManager = null;
		private static var _allowInstance: Boolean = false;
		
		private var _currentSelectedCard: Card;
		private var _battleGameComponent: BattleGameComponent;
		
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

		public function get battleGameComponent():BattleGameComponent
		{
			return _battleGameComponent;
		}

		public function set battleGameComponent(value:BattleGameComponent):void
		{
			_battleGameComponent = value;
		}


	}
}