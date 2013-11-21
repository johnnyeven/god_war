package com.xgame.godwar.core.general.proxy
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.parameters.card.SoulCardParameter;
	import com.xgame.godwar.common.pool.CardParameterPool;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SoulCardProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "SoulCardProxy";
		
		public function SoulCardProxy()
		{
			super(NAME, null);
		}
		
		public function getConfig(): void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/soul_card_config.xml", {onComplete: onGetConfig});
			_loader.load();
		}
		
		private function onGetConfig(evt: LoaderEvent): void
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
		}
	}
}