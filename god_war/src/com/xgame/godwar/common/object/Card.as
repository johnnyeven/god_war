package com.xgame.godwar.common.object
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.events.LoaderEvent;
	import com.xgame.godwar.common.parameters.card.CardParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.CardParameterPool;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.display.renders.Render;
	import com.xgame.godwar.enum.CardDisplayModeEnum;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	public class Card extends SpriteEx
	{
		private var _id: String;
		private var _resourceId: String;
		private var _name: String;
		private var _energy: int;
		private var _enabled: Boolean = true;
		private var _action: Boolean = false;
		
		private var _cardResourceBuffer: Bitmap;
		private var _displayMode: int;
		private var _baseLayer: Sprite;
		private var _effectLayer: Sprite;
		private var _infoLayer: Sprite;
		
		protected var _scrollRect: Rectangle;
		protected var _bgGlowFilter: GlowFilter;
		protected var _cardController: Sprite;
		protected var _parameter: CardParameter;
		protected var _inRound: Boolean = false;		//是否轮到自己
		protected var _inGame: Boolean = false;			//是否已出战
		protected var _inHand: Boolean = false;			//是否在手牌里
		
		public static const DISPLAY_MODE: Array = ["Small", "Medium", "Big"];
		
		public function Card(id: String = null, displayMode: int = 0)
		{
			_displayMode = displayMode;
			var nullBd: BitmapData;
			switch(_displayMode)
			{
				case CardDisplayModeEnum.SMALL:
					nullBd = new BitmapData(94, 143, true, 0);
					_scrollRect = new Rectangle(0, 0, 94, 143);
					break;
			}
			_bgGlowFilter = new GlowFilter(0xffff00);
			_cardResourceBuffer = new Bitmap(nullBd, "auto", true);
			_baseLayer = new Sprite();
			_baseLayer.addChild(_cardResourceBuffer);
			addChild(_baseLayer);
			
			_effectLayer = new Sprite();
			addChild(_effectLayer);
			
			_infoLayer = new Sprite();
			addChild(_infoLayer);
			_infoLayer.scrollRect = _scrollRect;
			_cardController = new Sprite();
			_infoLayer.addChild(_cardController);
			_cardController.x = -_scrollRect.width;
			_cardController.visible = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			
			_id = id;
			loadCardInfo();
			fixSize();
		}
		
		public function addEffect(effect: BitmapMovieDispaly): void
		{
			_effectLayer.addChild(effect);
		}
		
		public function clearClickListener(): void
		{
			removeEventListenerType(MouseEvent.CLICK);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseOver(evt: MouseEvent): void
		{
			if(_enabled)
			{
//				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1.1, scaleY: 1.1 }, ease: Strong.easeOut });
				this.filters = [_bgGlowFilter];
			}
		}
		
		protected function onMouseOut(evt: MouseEvent): void
		{
			if(_enabled)
			{
//				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1, scaleY: 1 }, ease: Strong.easeOut });
				this.filters = [];
			}
		}
		
		protected function onMouseClick(evt: MouseEvent): void
		{
			if(_enabled && _inRound)
			{
				if(_inHand || _inGame)
				{
					CardManager.instance.currentSelectedCard = this;
				}
				
				CardManager.instance.currentSelectedCard = this;
				GameManager.container.addEventListener(MouseEvent.CLICK, cancelSelect);
			}
		}
		
		public function cancelSelect(evt: MouseEvent = null): void
		{
			GameManager.container.removeEventListener(MouseEvent.CLICK, cancelSelect);
			CardManager.instance.currentSelectedCard = null;
		}
		
		protected function onAddToStage(evt: Event): void
		{
			loadCardResource();
			loadCardController();
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		public function showController(): void
		{
			UIUtils.setBrightness(_cardResourceBuffer, -0.8);
			_cardController.visible = true;
			TweenLite.to(_cardController, .5, {x: 0, ease: Strong.easeOut});
		}
		
		public function hideController(): void
		{
			UIUtils.setBrightness(_cardResourceBuffer, 0);
			TweenLite.to(_cardController, .5, {x: _cardResourceBuffer.width, ease: Strong.easeOut, onComplete: function(): void
			{
				_cardController.x = -_cardResourceBuffer.width;
				_cardController.visible = false;
			}});
		}
		
		protected function loadCardController(): void
		{
		}
		
		protected function loadCardInfo(): void
		{
			if(_id != null)
			{
				if(this is HeroCard)
				{
					_parameter = HeroCardParameterPool.instance.get(_id) as HeroCardParameter;
				}
				else
				{
					_parameter = CardParameterPool.instance.get(_id) as CardParameter;
				}
				
				_resourceId = _parameter.resourceId;
				_name = _parameter.name;
				_energy = _parameter.energy;
			}
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
			var bm: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card." + _id + "_" + DISPLAY_MODE[_displayMode]);
			if(bm != null)
			{
				_cardResourceBuffer.bitmapData = bm;
				fixSize();
			}
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
			mouseChildren = value;
			tabEnabled = value;
			filters = [];
			
			if(value)
			{
				UIUtils.setGray(this, false);
				UIUtils.setBrightness(this, 0);
			}
			else
			{
				TweenLite.to(this, .3, { transformAroundCenter: { scaleX: 1, scaleY: 1 }, ease: Strong.easeOut });
				UIUtils.setGray(this, true);
				UIUtils.setBrightness(this, -0.5);
			}
		}
		
		public function set interactive(value: Boolean): void
		{
			scaleX = 1;
			scaleY = 1;
			_enabled = value;
			mouseEnabled = value;
			tabEnabled = value;
			mouseChildren = value;
			tabEnabled = value;
			filters = [];
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
			filters = [];
			
			removeEventListeners();
		}
		
		override public function toString():String
		{
			return "CardId=" + _id;
		}

		public function get cardResourceBuffer():Bitmap
		{
			return _cardResourceBuffer;
		}

		public function get inGame():Boolean
		{
			return _inGame;
		}

		public function set inGame(value:Boolean):void
		{
			_inGame = value;
		}

		public function get inHand():Boolean
		{
			return _inHand;
		}

		public function set inHand(value:Boolean):void
		{
			_inHand = value;
		}

		public function get inRound():Boolean
		{
			return _inRound;
		}

		public function set inRound(value:Boolean):void
		{
			_inRound = value;
		}

		public function get energy():int
		{
			return _energy;
		}

		public function get action():Boolean
		{
			return _action;
		}

		public function set action(value:Boolean):void
		{
			_action = value;
		}

		public function get cardController():Sprite
		{
			return _cardController;
		}


	}
}