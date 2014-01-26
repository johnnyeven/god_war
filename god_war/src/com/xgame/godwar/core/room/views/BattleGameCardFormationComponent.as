package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameCardFormationComponent extends Component
	{
		private var container: MovieClip;
		private var _card0: MovieClip;
		private var _card1: MovieClip;
		private var _card2: MovieClip;
		private var _card3: MovieClip;
		private var _soulCard0: SoulCard;
		private var _soulCard1: SoulCard;
		private var _soulCard2: SoulCard;
		private var _soulCard3: SoulCard;
		
		public function BattleGameCardFormationComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameCardFormationComponent", null, false) as DisplayObjectContainer);
			
			container = getSkin("container") as MovieClip;
			_card0 = container.getChildByName("card0") as MovieClip;
			_card1 = container.getChildByName("card1") as MovieClip;
			_card2 = container.getChildByName("card2") as MovieClip;
			_card3 = container.getChildByName("card3") as MovieClip;
		}
		
		public function setCard(position: int, card: SoulCard): void
		{
			if(position >= 0 && card != null)
			{
				var current: MovieClip;
				
				if(position == 0)
				{
					_soulCard0 = card;
					current = _card0;
				}
				else if(position == 1)
				{
					_soulCard1 = card;
					current = _card1;
				}
				else if(position == 2)
				{
					_soulCard2 = card;
					current = _card2;
				}
				else if(position == 3)
				{
					_soulCard3 = card;
					current = _card3;
				}
				else
				{
					return;
				}
				
				TweenLite.killTweensOf(card);
				card.interactive = true;
				card.inGame = true;
				card.x = current.x;
				card.y = current.y;
				container.addChild(card);
				current.visible = false;
			}
		}
		
		public function removeCard(position: int): Card
		{
			if(position >= 0 && position <= 3)
			{
				var current: MovieClip;
				var card: Card;
				
				if(position == 0)
				{
					card = _soulCard0;
					_soulCard0 = null;
					current = _card0;
				}
				else if(position == 1)
				{
					card = _soulCard1;
					_soulCard1 = null;
					current = _card1;
				}
				else if(position == 2)
				{
					card = _soulCard2;
					_soulCard2 = null;
					current = _card2;
				}
				else if(position == 3)
				{
					card = _soulCard3;
					_soulCard3 = null;
					current = _card3;
				}
				
				TweenLite.killTweensOf(card);
				card.clearClickListener();
				card.interactive = false;
				card.inGame = false;
				if(container.contains(card))
				{
					container.removeChild(card);
				}
				current.visible = true;
				
				return card;
			}
			
			return null;
		}
		
		public function getCard(id: String): SoulCard
		{
			if(soulCard0 != null && soulCard0.id == id)
			{
				return soulCard0;
			}
			else if(soulCard1 != null && soulCard1.id == id)
			{
				return soulCard1;
			}
			else if(soulCard2 != null && soulCard2.id == id)
			{
				return soulCard2;
			}
			else if(soulCard3 != null && soulCard3.id == id)
			{
				return soulCard3;
			}
			return null;
		}

		public function get soulCard0():SoulCard
		{
			return _soulCard0;
		}

		public function get soulCard1():SoulCard
		{
			return _soulCard1;
		}

		public function get soulCard2():SoulCard
		{
			return _soulCard2;
		}

		public function get soulCard3():SoulCard
		{
			return _soulCard3;
		}

		public function get card0():MovieClip
		{
			return _card0;
		}
		
		public function get card1():MovieClip
		{
			return _card1;
		}
		
		public function get card2():MovieClip
		{
			return _card2;
		}
		
		public function get card3():MovieClip
		{
			return _card3;
		}
	}
}