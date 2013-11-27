package com.xgame.godwar.common.object
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.common.parameters.card.CardParameter;
	import com.xgame.godwar.common.pool.CardParameterPool;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.enum.CardDisplayModeEnum;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Card extends SpriteEx
	{
		private var _id: String;
		private var _resourceId: String;
		private var _name: String;
		private var _enabled: Boolean = true;
		
		private var _cardResourceBuffer: Bitmap;
		private var _displayMode: int;
		private var _baseLayer: Sprite;
		private var _effectLayer: Sprite;
		private var _infoLayer: Sprite;
		
		protected var _parameter: CardParameter;
		
		public static const DISPLAY_MODE: Array = ["Small", "Medium", "Big"];
		
		public function Card(id: String = null, displayMode: int = 0)
		{
			_displayMode = displayMode;
			_cardResourceBuffer = new Bitmap(null, "auto", true);
			_baseLayer = new Sprite();
			_baseLayer.addChild(_cardResourceBuffer);
			addChild(_baseLayer);
			
			_effectLayer = new Sprite();
			addChild(_effectLayer);
			
			_infoLayer = new Sprite();
			addChild(_infoLayer);
			
			if(id != null)
			{
				_id = id;
				_parameter = CardParameterPool.instance.get(_id) as CardParameter;
				loadCardInfo();
				loadCardResource();
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOver(evt: MouseEvent): void
		{
			if(_enabled)
			{
				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1.1, scaleY: 1.1 }, ease: Strong.easeOut });
			}
		}
		
		protected function onMouseOut(evt: MouseEvent): void
		{
			if(_enabled)
			{
				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1, scaleY: 1 }, ease: Strong.easeOut });
			}
		}
		
		protected function loadCardInfo(): void
		{
			_resourceId = _parameter.resourceId;
			_name = _parameter.name;
		}
		
		protected function loadCardResource(): void
		{
			var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card." + _id + "_" + DISPLAY_MODE[_displayMode]);
			if(bd == null)
			{
				bd = ResourcePool.instance.getBitmapData("assets.resource.card.UnknowCard_Small");
				ResourceCenter.instance.load(_resourceId, null, onCardResourceLoadComplete);
			}
			_cardResourceBuffer.bitmapData = bd;
			fixSize();
		}
		
		private function fixSize(): void
		{
			switch(_displayMode)
			{
				case CardDisplayModeEnum.SMALL:
					_cardResourceBuffer.width = 94;
					_cardResourceBuffer.height = 143;
					break;
			}
		}
		
		private function onCardResourceLoadComplete(evt: LoaderEvent): void
		{
			_cardResourceBuffer.bitmapData = ResourcePool.instance.getBitmapData("assets.resource.card." + _id + "_" + DISPLAY_MODE[_displayMode]);
			fixSize();
		}

		public function get displayMode():int
		{
			return _displayMode;
		}

		public function set displayMode(value:int):void
		{
			_displayMode = value;
			fixSize();
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get cardName():String
		{
			return _name;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = value;
			tabEnabled = value;
			
			if(value)
			{
				UIUtils.setBrightness(this, 0);
			}
			else
			{
				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1, scaleY: 1 }, ease: Strong.easeOut });
				UIUtils.setBrightness(this, -0.7);
			}
		}

		public function clone(): Card
		{
			return new Card(_id, _displayMode);
		}
		
		public function dispose(): void
		{
			while(_baseLayer.numChildren > 0)
			{
				_baseLayer.removeChildAt(0);
			}
			while(_effectLayer.numChildren > 0)
			{
				_effectLayer.removeChildAt(0);
			}
			while(_infoLayer.numChildren > 0)
			{
				_infoLayer.removeChildAt(0);
			}
			_baseLayer = null;
			_effectLayer = null;
			_infoLayer = null;
			_cardResourceBuffer.bitmapData = null;
			_cardResourceBuffer = null;
			
			removeEventListeners();
		}
	}
}