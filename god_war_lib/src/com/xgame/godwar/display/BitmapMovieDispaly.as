package com.xgame.godwar.display
{
	import com.xgame.godwar.common.behavior.Behavior;
	import com.xgame.godwar.configuration.GlobalContextConfig;
	import com.xgame.godwar.display.BitmapDisplay;
	import com.xgame.godwar.events.DisplayEvent;
	
	import flash.geom.Rectangle;

	public class BitmapMovieDispaly extends BitmapDisplay
	{
		protected var _currentFrame: uint;
		protected var _prevFrame: uint;
		protected var _totalFrame: uint;
		protected var _isLoop: Boolean;
		protected var _isStop: Boolean;
		protected var _isEnd: Boolean;
		protected var _lastFrameTime: uint;
		protected var _playTime: uint;
		
		public function BitmapMovieDispaly(behavior: Behavior = null)
		{
			super(behavior);
			_currentFrame = 0;
			_prevFrame = 0;
			_totalFrame = 0;
			_isLoop = true;
			_isStop = false;
			_isEnd = false;
			_lastFrameTime = GlobalContextConfig.Timer;
		}
		
		protected function updateFPS(): void
		{
			_totalFrame = _graphic.frameTotal;
			_playTime = _graphic.fps == 0 ? 0 : (1000 / _graphic.fps);
		}
		
		override protected function rebuild():void
		{
			super.rebuild();
			updateFPS();
		}
		
		protected function step(): Boolean
		{
			if(_graphic == null || _graphic.fps == 0)
			{
				return false;
			}
			if(GlobalContextConfig.Timer - _lastFrameTime > _playTime && !_isEnd && !_isStop)
			{
				_lastFrameTime = GlobalContextConfig.Timer;
				_prevFrame = _currentFrame;
				
				if(_currentFrame >= _totalFrame - 1)
				{
					_isLoop ? _currentFrame = 0 : _isEnd = true;
				}
				else
				{
					_currentFrame++;
				}
			}
			return true;
		}
		
		override protected function updateActionPre():void
		{
			step();
		}
		
		override protected function updateActionAfter():void
		{
			super.updateActionAfter();
			
			if(_isEnd && !_isStop)
			{
				_isStop = true;
				var evt: DisplayEvent = new DisplayEvent(DisplayEvent.MOVIE_PLAY_COMPLETE);
				dispatchEvent(evt);
			}
		}

		public function get currentFrame():uint
		{
			return _currentFrame;
		}

		public function set currentFrame(value:uint):void
		{
			_currentFrame = value;
		}

		public function get prevFrame():uint
		{
			return _prevFrame;
		}

		public function get loop():Boolean
		{
			return _isLoop;
		}

		public function set loop(value:Boolean):void
		{
			_isLoop = value;
			if(value)
			{
				_isEnd = false;
			}
		}

		public function get isKeepStatic(): Boolean
		{
			return !_isLoop && _isEnd;
		}
		
		override public function get rect():Rectangle
		{
			_rect.x = _currentFrame * _graphic.frameWidth;
//			_rect.y = _direction * _graphic.frameHeight;
			_rect.y = 0;
			_rect.width = _graphic.frameWidth;
			_rect.height = _graphic.frameHeight;
			return _rect;
		}
		
		override public function get renderLine():uint
		{
//			return _direction;
			return 0;
		}
		
		override public function get renderFrame():uint
		{
			return _currentFrame;
		}
	}
}