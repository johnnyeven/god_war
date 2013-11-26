package com.xgame.godwar.common.parameters
{
	import com.xgame.godwar.common.object.HeroCard;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.utils.StringUtils;

	public class CardGroupParameter extends Object
	{
		public var groupId: int = int.MIN_VALUE;
		public var groupName: String = null;
		public var cardList: Array = new Array();
		public var cardListReady: Boolean = false;
		public static const CARD_TYPE: Array = [SoulCard, HeroCard];
		
		public function CardGroupParameter()
		{
			super();
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
					cardClass = CARD_TYPE[int(tmp[0])];
					cardList.push(new cardClass(tmp[1]));
				}
			}
			cardListReady = true;
		}
	}
}