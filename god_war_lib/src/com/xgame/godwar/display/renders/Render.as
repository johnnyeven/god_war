package com.xgame.godwar.display.renders
{
	import com.xgame.godwar.display.BitmapDisplay;

	public class Render
	{
		protected var _target: BitmapDisplay;
		
		public function Render()
		{
		}
		
		public function render(target: BitmapDisplay = null, force: Boolean = false): void
		{
			if(target == null)
			{
				target = _target;
			}
			draw(target, _target.renderLine, _target.renderFrame);
		}
		
		protected function draw(target: BitmapDisplay = null, line: uint = 0, frame: uint = 0): void
		{
			if(target == null)
			{
				target = _target;
			}
			if(_target.graphic != null && target.buffer != null)
			{
				_target.graphic.render(target.buffer, line, frame);
			}
		}
		
		public function set target(value: BitmapDisplay): void
		{
			if(value != null)
			{
				_target = value;
			}
		}
	}
}