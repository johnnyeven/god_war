package com.xgame.godwar.core.center
{
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.display.BitmapDisplay;
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
		
		public function get instance(): EffectCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new EffectCenter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function addEffect(effect: BitmapDisplay): void
		{
			if(effectList.indexOf(effect) >= 0)
			{
				return;
			}
			GameManager.instance.addView(effect);
			effectList.push(effect);
		}
		
		public function removeEffect(effect: BitmapDisplay, isDispose: Boolean = true): void
		{
			var index: int = effectList.indexOf(effect);
			if(index >= 0)
			{
				effectList.splice(index, 1);
				GameManager.instance.removeView(effect);
				
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