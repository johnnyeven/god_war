package com.xgame.godwar.common.parameters
{
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.HeroCard;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.utils.StringUtils;

	public class CardGroupParameter extends Object
	{
		public var groupId: int = int.MIN_VALUE;
		public var groupName: String = null;
		public var cardList: Array = new Array();
		public var energyCost: int;
		public var cardListReady: Boolean = false;
		public static const CARD_TYPE: Array = [SoulCard, HeroCard];
		
		public function CardGroupParameter()
		{
			super();
		}
		
		private function getCardTypeCode(card: Card): int
		{
			if(card is SoulCard)
			{
				return 0;
			}
			else if(card is HeroCard)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		
		private function getCardType(type: int): Class
		{
			return CARD_TYPE[type];
		}
		
		public function get cards(): String
		{
			var tmp: Array = new Array();
			for(var i: String in cardList)
			{
				tmp.push(getCardTypeCode(cardList[i]) + ":" + cardList[i].id);
			}
			return tmp.join(",");
		}
		
		public function set cards(value: String): void
		{
			if(!cardListReady && !StringUtils.empty(value))
			{
				var array: Array = value.split(",");
				var tmp: Array;
				var cardClass: Class;
				for(var i: String in array)
				{
					tmp = array[i].split(":");
					cardClass = getCardType(int(tmp[0]));
					cardList.push(new cardClass(tmp[1]));
				}
			}
			cardListReady = true;
		}
	}
}