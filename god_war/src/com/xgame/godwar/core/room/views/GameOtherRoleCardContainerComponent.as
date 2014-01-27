package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class GameOtherRoleCardContainerComponent extends Component
	{
		private var _backContainer: Dictionary;
		private var _cardContainer: Dictionary;		//width: 38, height: 57
		
		public function GameOtherRoleCardContainerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.GameOtherRoleCardContainerComponent", null, false) as DisplayObjectContainer);
			
			_backContainer = new Dictionary();
			_cardContainer = new Dictionary();
		}
		
		public function addCardBack(position: int = 0): void
		{
			if(_backContainer[position] != null)
			{
				return;
			}
			
			var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.BackCard_Small");
			var bitmap: Bitmap = new Bitmap(bd, "auto", true);
			bitmap.width = 38;
			bitmap.height = 57;
			
			var sp: Sprite = new Sprite();
			sp.addChild(bitmap);
			bitmap.x = -bitmap.width / 2;
			
			addChild(sp);
			_backContainer[position] = sp;
			
			sp.x = position * (sp.width - 5) + sp.width / 2;
			sp.y = -sp.height / 2;
			sp.alpha = 0;
			
			TweenLite.to(sp, .5, {y: 0, alpha: 1});
		}
		
		public function addCard(position: int, card: SoulCard, callback: Function = null): void
		{
			if(card != null)
			{
				var sp: Sprite = getBack(position);
				if(sp == null)
				{
					return;
				}
				_cardContainer[card.id] = card;
				card.width = 38;
				card.height = 57;
				card.x = sp.x;
				card.y = sp.y;
				addChild(card);
			}
		}
		
		public function removeCard(cardId: String): void
		{
			if(_cardContainer.hasOwnProperty(cardId))
			{
				_cardContainer[cardId] = null;
				delete _cardContainer[cardId];
			}
		}
		
		public function getCard(cardId: String): SoulCard
		{
			if(_cardContainer.hasOwnProperty(cardId))
			{
				return _cardContainer[cardId] as SoulCard;
			}
			return null;
		}
		
		public function getBack(position: int): Sprite
		{
			if(_backContainer.hasOwnProperty(position))
			{
				return _backContainer[position] as Sprite;
			}
			return null;
		}
	}
}