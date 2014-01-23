package com.xgame.godwar.core.general.proxy
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.parameters.skill.SkillParameter;
	import com.xgame.godwar.common.pool.SkillParameterPool;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SkillProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "SkillProxy";
		
		public function SkillProxy()
		{
			super(NAME, null);
		}
		
		public function getConfig(): void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/skill_config.xml", {onComplete: onGetSkillConfig});
			_loader.load();
		}
		
		private function onGetSkillConfig(evt: LoaderEvent): void
		{
			var _config: XML = (evt.currentTarget as XMLLoader).content;
			var parameter: SkillParameter;
			
			for(var i: int = 0; i < _config.skill.length(); i++)
			{
				parameter = new SkillParameter();
				parameter.id = _config.skill[i].id;
				parameter.name = _config.skill[i].name;
				parameter.level = _config.skill[i].level;
				parameter.target = _config.skill[i].target;
				parameter.resource = _config.skill[i].resource;
				SkillParameterPool.instance.add(parameter.id, parameter);
			}
		}
	}
}