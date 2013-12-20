package com.xgame.godwar.core.general.proxy
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_RequestCardList;
	import com.xgame.godwar.common.commands.sending.Send_Info_RequestCardList;
	import com.xgame.godwar.common.object.HeroCard;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.card.CardContainerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.CardParameterPool;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CardProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "CardProxy";
		public var soulCardIndex: Dictionary;
		public var container: CardContainerParameter;
		
		public function CardProxy()
		{
			super(NAME, null);
			
			container = new CardContainerParameter();
			
			CommandList.instance.bind(SocketContextConfig.INFO_REQUEST_CARD_LIST, Receive_Info_RequestCardList);
			CommandCenter.instance.add(SocketContextConfig.INFO_REQUEST_CARD_LIST, onRequestCardList);
		}
		
		public function getConfig(): void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/soul_card_config.xml", {onComplete: onGetSoulConfig});
			_loader.load();
		}
		
		private function onGetSoulConfig(evt: LoaderEvent): void
		{
			var _config: XML = (evt.currentTarget as XMLLoader).content;
			var parameter: SoulCardParameter;
			
			for(var i: int = 0; i < _config.card.length(); i++)
			{
				parameter = new SoulCardParameter();
				parameter.id = _config.card[i].id;
				parameter.resourceId = _config.card[i].resource_id;
				parameter.name = _config.card[i].name;
				parameter.attack = _config.card[i].attack;
				parameter.def = _config.card[i].def;
				parameter.mdef = _config.card[i].mdef;
				parameter.health = _config.card[i].health;
				parameter.level = _config.card[i].level;
				parameter.race = _config.card[i].race;
				CardParameterPool.instance.add(parameter.id, parameter);
			}
			
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/hero_card_config.xml", {onComplete: onGetHeroConfig});
			_loader.load();
		}
		
		private function onGetHeroConfig(evt: LoaderEvent): void
		{
			var _config: XML = (evt.currentTarget as XMLLoader).content;
			var parameter: HeroCardParameter;
			
			var avatar: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			if(avatar == null)
			{
				avatar = new AvatarConfigProxy();
				facade.registerProxy(avatar);
				avatar.getAvatarConfig();
				
				return;
			}
			
			for(var i: int = 0; i < _config.card.length(); i++)
			{
				parameter = new HeroCardParameter();
				parameter.id = _config.card[i].id;
				parameter.resourceId = _config.card[i].resource_id;
				parameter.name = _config.card[i].name;
				parameter.nickname = _config.card[i].nickname;
				parameter.attack = _config.card[i].attack;
				parameter.def = _config.card[i].def;
				parameter.mdef = _config.card[i].mdef;
				parameter.hit = _config.card[i].hit;
				parameter.flee = _config.card[i].flee;
				parameter.health = _config.card[i].health;
				parameter.race = _config.card[i].race;
				parameter.avatarPath = avatar.avatarBasePath + parameter.resourceId + ".png";
				parameter.avatarPathBig = avatar.avatarBasePath + parameter.resourceId + "_big.png";
				HeroCardParameterPool.instance.add(parameter.id, parameter);
			}
			
			if(getData() == null)
			{
				requestCardList();
			}
		}
		
		public function requestCardList(): void
		{
			var protocol: Send_Info_RequestCardList = new Send_Info_RequestCardList();
			
			CommandCenter.instance.send(protocol);
		}
		
		private function onRequestCardList(protocol: Receive_Info_RequestCardList): void
		{
			soulCardIndex = new Dictionary();
			
			var tmp: Array = protocol.cardList.split(',');
			var list: Array = new Array();
			var card: SoulCard;
			for(var i: String in tmp)
			{
				card = new SoulCard(tmp[i]);
				list.push(card);
				soulCardIndex[tmp[i]] = list.length-1;
			}
			container.soulCardList = list;
			
			tmp = protocol.heroCardList.split(',');
			list = new Array();
			var heroCard: HeroCard;
			for(i in tmp)
			{
				heroCard = new HeroCard(tmp[i]);
				list.push(card);
				soulCardIndex[tmp[i]] = list.length-1;
			}
			container.heroCardList = list;
			
			setData(container);
		}
	}
}