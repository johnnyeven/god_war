package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class BattleGameCardFormationComponent extends Component
	{
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
			
			card0 = getSkin("card0") as MovieClip;
			card1 = getSkin("card1") as MovieClip;
			card2 = getSkin("card2") as MovieClip;
			card3 = getSkin("card3") as MovieClip;
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
				card.interactive = false;
				card.width = current.width;
				card.height = current.height;
				card.x = current.x;
				card.y = current.y;
				current.visible = false;
				addChild(card);
			}
		}
	}
}