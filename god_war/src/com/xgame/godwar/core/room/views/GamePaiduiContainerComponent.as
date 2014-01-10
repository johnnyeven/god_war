package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
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
		}
		
		private function onSoulPaiduiClick(evt: MouseEvent): void
		{
			if(_countLimit > 0)
			{
				var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.BackCard_Small");
				var bitmap: Bitmap = new Bitmap(bd);
				GameManager.instance.addView(bitmap);
				bitmap.x = _soulPaidui.x;
				bitmap.y = _soulPaidui.y;
				
				TweenLite.to(bitmap, .3, {x: 500, y: 600, ease: Strong.easeIn});
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
				GameManager.instance.addView(bitmap);
				bitmap.x = _supplyPaidui.x;
				bitmap.y = _supplyPaidui.y;
				
				TweenLite.to(bitmap, .5, {x: 500, y: 600, ease: Strong.easeOut});
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