package com.xgame.godwar.liteui.component
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class RadioGroup
	{
		private var _container: Dictionary;
		
		public function RadioGroup()
		{
			_container = new Dictionary();
		}
		
		public function addRadio(value: Radio, groupName: String = null): void
		{
			if(groupName == null)
			{
				groupName = "default";
			}
			if(_container[groupName] == null)
			{
				_container[groupName] = new Vector.<Radio>();
			}
			if(_container[groupName].indexOf(value) == -1)
			{
				value.radioGroup = groupName;
				value.addEventListener(MouseEvent.CLICK, onRadioClick);
				_container[groupName].push(value);
			}
		}
		
		public function removeRadio(value: Radio, groupName: String = null): void
		{
			var list: Vector.<Radio>;
			var i: int;
			
			if(groupName == null)
			{
				groupName = "default";
			}
			list = _container[groupName] as Vector.<Radio>;
			i = list.indexOf(value);
			if(i >= 0)
			{
				value.radioGroup = "default";
				value.removeEventListener(MouseEvent.CLICK, onRadioClick);
				list.splice(i, 1);
			}
			if(list.length == 0)
			{
				_container[groupName] = null;
				delete _container[groupName];
			}
		}
		
		private function onRadioClick(evt: MouseEvent): void
		{
			var radio: Radio = evt.currentTarget as Radio;
			var list: Vector.<Radio> = _container[radio.radioGroup];
			if(list != null)
			{
				for(var i: int = 0; i<list.length; i++)
				{
					list[i].checked = false;
				}
				radio.checked = true;
			}
		}
	}
}