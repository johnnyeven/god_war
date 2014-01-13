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
	import flash.events.MouseEvent;
	
	public class GamePaiduiContainerComponent extends Component
	{
		private var _lblCaption: Label;
		private var _btnOk: CaptionButton;
		private var _soulPaidui: GamePaiDuiComponent;
		private var _supplyPaidui: GamePaiDuiComponent;
		private var _soulCount: int;
		private var _supplyCount: int;
		private var _countLimit: int = 3;
		private var _bitmapContainer: Vector.<Bitmap>;
		private var _cardContainer: Vector.<Card>;
		
		public function GamePaiduiContainerComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.GamePaiduiContainerComponent", null, false) as DisplayObjectContainer);
			
			_lblCaption = getUI(Label, "caption") as Label;
			_btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			
			sortChildIndex();
			
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
			
			_bitmapContainer = new Vector.<Bitmap>();
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
				var bitmap: Bitmap = _bitmapContainer[0];
				if(bitmap != null)
				{
					var startX: int = 200;
					for(var i: int = 0; i<_bitmapContainer.length; i++)
					{
						bitmap = _bitmapContainer[i];
						if(bitmap != null)
						{
							TweenLite.to(bitmap, .5, {rotationY: 180, y: bitmap.y - 100, x: startX});
							startX += bitmap.width + 25;
						}
					}
				}
			}
		}
		
		private function onSoulPaiduiClick(evt: MouseEvent): void
		{
			if(_countLimit > 0)
			{
				var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.BackCard_Small");
				var bitmap: Bitmap = new Bitmap(bd);
				addChild(bitmap);
				_bitmapContainer.push(bitmap);
				bitmap.x = _soulPaidui.x;
				bitmap.y = _soulPaidui.y;
				
				TweenLite.to(bitmap, .5, {x: (width - bitmap.width) / 2, y: bitmap.y + 200, ease: Strong.easeOut});
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
				addChild(bitmap);
				_bitmapContainer.push(bitmap);
				bitmap.x = _supplyPaidui.x;
				bitmap.y = _supplyPaidui.y;
				
				TweenLite.to(bitmap, .5, {x: (width - bitmap.width) / 2, y: bitmap.y + 200, ease: Strong.easeOut});
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