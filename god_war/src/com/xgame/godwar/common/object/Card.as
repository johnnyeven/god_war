package com.xgame.godwar.common.object
{
	import com.xgame.godwar.common.parameters.card.CardParameter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class Card extends Sprite
	{
		private var _id: String;
		private var _name: String;
		
		private var _cardResourceBuffer: Bitmap;
		private var _baseLayer: Sprite;
		private var _effectLayer: Sprite;
		private var _infoLayer: Sprite;
		
		public function Card(id: String = null)
		{
			_cardResourceBuffer = new Bitmap();
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
				loadCardResource();
			}
		}
		
		protected function loadCardInfo(parameter: CardParameter): void
		{
			_name = parameter.name;
		}
		
		protected function loadCardResource(): void
		{
			
		}
	}
}