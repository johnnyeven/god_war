package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.skill.SkillParameter;
	import com.xgame.godwar.common.pool.SkillParameterPool;
	import com.xgame.godwar.utils.StringUtils;

	public class Skill
	{
		private var _id: String;
		private var _name: String;
		private var _level: int;
		private var _target: String;
		private var _resource: String;
		
		public function Skill(id: String)
		{
			_id = id;
			loadSkillInfo();
		}
		
		protected function loadSkillInfo(): void
		{
			if(!StringUtils.empty(_id))
			{
				var parameter: SkillParameter = SkillParameterPool.instance.get(_id) as SkillParameter;
				if(parameter != null)
				{
					_name = parameter.name;
					_level = parameter.level;
					_target = parameter.target;
					_resource = parameter.resource;
				}
			}
		}

		public function get id():String
		{
			return _id;
		}

		public function get name():String
		{
			return _name;
		}

		public function get level():int
		{
			return _level;
		}

		public function get resource():String
		{
			return _resource;
		}

		public function get target():String
		{
			return _target;
		}


	}
}