package com.xgame.godwar.core.center
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.LoaderCore;
	import com.xgame.godwar.common.parameters.skill.SkillParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.common.pool.SkillParameterPool;
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.display.BitmapDisplay;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.display.ResourceData;
	import com.xgame.godwar.display.renders.Render;
	import com.xgame.godwar.utils.debug.Debug;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;

	public class EffectCenter
	{
		private var effectList: Vector.<BitmapDisplay>;
		
		private static var _allowInstance: Boolean = false;
		private static var _instance: EffectCenter;
		
		public function EffectCenter()
		{
			if(_allowInstance)
			{
				effectList = new Vector.<BitmapDisplay>();
			}
			else
			{
				throw new IllegalOperationError("不能实例化这个类");
			}
		}
		
		public static function get instance(): EffectCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new EffectCenter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function getEffect(name: String): BitmapMovieDispaly
		{
			var parameter: SkillParameter = SkillParameterPool.instance.get(name) as SkillParameter;
			if(parameter != null)
			{
				var effect: BitmapMovieDispaly = new BitmapMovieDispaly();
				var resource: ResourceData = ResourcePool.instance.getResourceData(parameter.classId);
				if(resource != null)
				{
					effect.graphic = resource;
				}
				else
				{
					CONFIG::DebugMode
					{
						Debug.info(this, "开始加载资源 " + parameter.skillId);
					}
					ResourceCenter.instance.load(parameter.skillId, {id: parameter.id, resourceId: parameter.classId, effect: effect}, onResourceLoaded);
				}
				effect.render = new Render();
				
				return effect;
			}
			return null;
		}
		
		private function onResourceLoaded(evt: LoaderEvent): void
		{
			CONFIG::DebugMode
			{
				Debug.info(this, "资源加载完成");
			}
			var loader: LoaderCore = evt.currentTarget as LoaderCore;
			var effect: BitmapMovieDispaly = loader.vars.vars.effect as BitmapMovieDispaly;
			var resourceId: String = loader.vars.vars.resourceId;
			
			var resource: ResourceData = ResourcePool.instance.getResourceData(resourceId);
			if(resource != null)
			{
				effect.graphic = resource;
			}
		}
		
		public function addEffect(effect: BitmapDisplay): void
		{
			if(effectList.indexOf(effect) >= 0)
			{
				return;
			}
			effectList.push(effect);
		}
		
		public function removeEffect(effect: BitmapDisplay, isDispose: Boolean = true): void
		{
			var index: int = effectList.indexOf(effect);
			if(index >= 0)
			{
				effectList.splice(index, 1);
				
				if(isDispose)
				{
					effect.dispose();
				}
			}
		}
		
		public function start(): void
		{
			TimerManager.instance.add(33, update);
		}
		
		public function stop(): void
		{
			TimerManager.instance.remove(update);
		}
		
		private function update(): void
		{
			updateTimer();
			
			var bd: BitmapDisplay;
			for(var i: int = 0; i<effectList.length; i++)
			{
				bd = effectList[i];
				if(bd != null)
				{
					bd.update();
				}
			}
		}
		
		private function updateTimer(): void
		{
			GlobalContextConfig.Timer = getTimer();
		}
	}
}