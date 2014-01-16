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
		private var card0: MovieClip;
		private var card1: MovieClip;
		private var card2: MovieClip;
		private var card3: MovieClip;
		private var soulCard0: SoulCard;
		private var soulCard1: SoulCard;
		private var soulCard2: SoulCard;
		private var soulCard3: SoulCard;
		
		public function BattleGameCardFormationComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameCardFormationComponent", null, false) as DisplayObjectContainer);
			
			container = getSkin("container") as MovieClip;
			card0 = container.getChildByName("card0") as MovieClip;
			card1 = container.getChildByName("card1") as MovieClip;
			card2 = container.getChildByName("card2") as MovieClip;
			card3 = container.getChildByName("card3") as MovieClip;
		}
		
		public function setCard(position: int, card: SoulCard): void
		{
			if(position >= 0 && card != null)
			{
				var current: MovieClip;
				
				if(position == 0)
				{
					soulCard0 = card;
					current = card0;
				}
				else if(position == 1)
				{
					soulCard1 = card;
					current = card1;
				}
				else if(position == 2)
				{
					soulCard2 = card;
					current = card2;
				}
				else if(position == 3)
				{
					soulCard3 = card;
					current = card3;
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
					card = soulCard0;
					current = card0;
				}
				else if(position == 1)
				{
					card = soulCard1;
					current = card1;
				}
				else if(position == 2)
				{
					card = soulCard2;
					current = card2;
				}
				else if(position == 3)
				{
					card = soulCard3;
					current = card3;
				}
				
				TweenLite.killTweensOf(card);
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
	}
}