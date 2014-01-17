package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GamePaiduiContainerComponent extends Component
	{
		private var _bg: MovieClip;
		private var _lblCaption: Label;
		private var _btnOk: CaptionButton;
		private var _btnConfirm: CaptionButton;
		private var _soulPaidui: GamePaiDuiComponent;
		private var _supplyPaidui: GamePaiDuiComponent;
		private var _soulCount: int;
		private var _supplyCount: int;
		private var _countLimit: int = 3;
		private var _bitmapContainer: Vector.<Sprite>;
		private var _cardContainer: Vector.<Card>;
		
		public function GamePaiduiContainerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.GamePaiduiContainerComponent", null, false) as DisplayObjectContainer);
			
			_bg = getSkin("bg") as MovieClip;
			_lblCaption = getUI(Label, "caption") as Label;
			_btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			_btnConfirm = getUI(CaptionButton, "btnConfirm") as CaptionButton;
			
			sortChildIndex();
			_btnConfirm.visible = false;
			
			_soulPaidui = new GamePaiDuiComponent();
			_soulPaidui.x = 110;
			_soulPaidui.y = 76;
			addChild(_soulPaidui);
			
			_supplyPaidui = new GamePaiDuiComponent();
			_supplyPaidui.x = 320;
			_supplyPaidui.y = 76;
			addChild(_supplyPaidui);
			
			_soulPaidui.addEventListener(MouseEvent.CLICK, onSoulPaiduiClick);
			_supplyPaidui.addEventListener(MouseEvent.CLICK, onSupplyPaiduiClick);
			_btnOk.addEventListener(MouseEvent.CLICK, onBtnOkClick);
			_btnConfirm.addEventListener(MouseEvent.CLICK, onBtnConfirmClick);
			
			_bitmapContainer = new Vector.<Sprite>();
			_cardContainer = new Vector.<Card>();
		}
		
		public function addCard(card: Card): void
		{
			_cardContainer.push(card);
		}
		
		public function showCards(): void
		{
			if(_bitmapContainer.length > 0)
			{
				var bitmap: Sprite = _bitmapContainer[0];
				hidePanel();
				if(bitmap != null)
				{
					var indent: int = 25;
					var startX: int = (width - ( 3 * bitmap.width + 2 * indent)) / 2 + bitmap.width / 2;
					var card: Card;
					var sp: Sprite;
					for(var i: int = 0; i<_bitmapContainer.length; i++)
					{
						bitmap = _bitmapContainer[i];
						if(bitmap != null)
						{
							if(_cardContainer[i] != null)
							{
								card = _cardContainer[i];
								sp = new Sprite();
								sp.addChild(card);
								card.x = -card.width / 2;
								sp.x = bitmap.x;
								sp.y = bitmap.y;
								sp.rotationY = -180;
								sp.visible = false;
								addChild(sp);
							}
							
							TweenLite.to(bitmap, .5, {rotationY: 180, y: bitmap.y - 250, x: startX, onUpdate: onBitmapAnimateProgress, onUpdateParams: [bitmap, sp]});
							TweenLite.to(sp, .5, {rotationY: 0, y: sp.y - 250, x: startX, onComplete: onBitmapAnimateComplete, onCompleteParams: [sp]});
							startX += bitmap.width + indent;
						}
					}
				}
			}
		}
		
		private function onBitmapAnimateProgress(bitmap: Sprite, sp: Sprite): void
		{
			if(bitmap.rotationY >= 90)
			{
				sp.visible = true;
				bitmap.visible = false;
				TweenLite.killTweensOf(bitmap);
				
				removeChild(bitmap);
				var index: int = _bitmapContainer.indexOf(bitmap);
				if(index >= 0)
				{
					_bitmapContainer.splice(index, 1);
				}
				bitmap.removeChildren();
				bitmap = null;
			}
		}
		
		private function onBitmapAnimateComplete(sp: Sprite): void
		{
			_btnConfirm.visible = true;
		}
		
		private function onSoulPaiduiClick(evt: MouseEvent): void
		{
			if(_countLimit > 0)
			{
				var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.BackCard_Small");
				var bitmap: Bitmap = new Bitmap(bd);
				var sp: Sprite = new Sprite();
				sp.addChild(bitmap);
				bitmap.x = -bitmap.width / 2;
				
				addChild(sp);
				_bitmapContainer.push(sp);
				sp.x = _soulPaidui.x + sp.width / 2;
				sp.y = _soulPaidui.y;
				
				TweenLite.to(sp, .5, {x: width / 2, y: sp.y + 250, ease: Strong.easeOut});
				_countLimit--;
				_soulCount++;
			}
		}
		
		private function onSupplyPaiduiClick(evt: MouseEvent): void
		{
			if(_countLimit > 0)
			{
				var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.BackCard_Small");
				var bitmap: Bitmap = new Bitmap(bd);
				var sp: Sprite = new Sprite();
				sp.addChild(bitmap);
				bitmap.x = -bitmap.width / 2;
				
				addChild(sp);
				_bitmapContainer.push(sp);
				sp.x = _supplyPaidui.x + sp.width / 2;
				sp.y = _supplyPaidui.y;
				
				TweenLite.to(sp, .5, {x: width / 2, y: sp.y + 250, ease: Strong.easeOut});
				_countLimit--;
				_supplyCount++;
			}
		}
		
		private function onBtnOkClick(evt: MouseEvent): void
		{
			if(_countLimit > 0)
			{
				
			}
			else
			{
				var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.ROUND_STANDBY_EVENT);
				event.value = [_soulCount, _supplyCount];
				dispatchEvent(event);
				
				_btnOk.enabled = false;
			}
		}
		
		private function onBtnConfirmClick(evt: MouseEvent): void
		{
			var card: Card;
			var delay: Number = 0;
			var targetY: int = GameManager.container.stageHeight - y;
			for(var i: int = 0; i<_cardContainer.length; i++)
			{
				card = _cardContainer[i];
				card.interactive = false;
				
				TweenLite.to(card, .5, {y: targetY, delay: delay, ease: Strong.easeIn, onComplete: onCardComplete, onCompleteParams: [card]});
				delay += .1;
			}
		}
		
		private function onCardComplete(card: Card): void
		{
			card.interactive = true;
			
			var index: int = _cardContainer.indexOf(card);
			if(index >= 0)
			{
				_cardContainer.splice(index, 1);
			}
			
			var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.CHOUPAI_EVENT);
			event.value = card;
			card.inRound = true;
			dispatchEvent(event);
			
			if(_cardContainer.length == 0)
			{
				visible = false;
				_btnConfirm.visible = false;
				showPanel();
//				event = new BattleGameEvent(BattleGameEvent.CHOUPAI_COMPLETE_EVENT);
//				dispatchEvent(event);
			}
		}
		
		private function hidePanel(): void
		{
			TweenLite.to(_bg, .5, {alpha: 0, onComplete: function(): void
			{
				_bg.visible = false;
				_bg.alpha = 1;
			}});
			TweenLite.to(_lblCaption, .5, {alpha: 0, onComplete: function(): void
			{
				_lblCaption.visible = false;
				_lblCaption.alpha = 1;
			}});
			TweenLite.to(_btnOk, .5, {alpha: 0, onComplete: function(): void
			{
				_btnOk.visible = false;
				_btnOk.alpha = 1;
			}});
			TweenLite.to(_soulPaidui, .5, {alpha: 0, onComplete: function(): void
			{
				_soulPaidui.visible = false;
				_soulPaidui.alpha = 1;
			}});
			TweenLite.to(_supplyPaidui, .5, {alpha: 0, onComplete: function(): void
			{
				_supplyPaidui.visible = false;
				_supplyPaidui.alpha = 1;
			}});
		}
		
		private function showPanel(): void
		{
			_bg.visible = true;
			_lblCaption.visible = true;
			_btnOk.visible = true;
			_soulPaidui.visible = true;
			_supplyPaidui.visible = true;
		}

		public function get soulCount():int
		{
			return _soulCount;
		}

		public function get supplyCount():int
		{
			return _supplyCount;
		}

		public function set countLimit(value:int):void
		{
			_countLimit = value;
		}
	}
}