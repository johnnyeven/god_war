package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BattleGameChouPaiComponent extends Component
	{
		private var btnOk: CaptionButton;
		private var container: Sprite;
		private var cardAnimateContainer: Vector.<Card>;
		private var inProcess: Boolean = false;
		
		public function BattleGameChouPaiComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameChouPaiComponent", null, false) as DisplayObjectContainer);
			
			btnOk = getUI(CaptionButton, "btnOk") as CaptionButton;
			container = new Sprite();
			addChild(container);
			
			sortChildIndex();
			
			cardAnimateContainer = new Vector.<Card>();
			btnOk.addEventListener(MouseEvent.CLICK, onBtnOkClick);
		}
		
		public function addCardAnimate(card: Card): void
		{
			cardAnimateContainer.push(card);
		}
		
		public function startCardAnimate(): void
		{
			if(inProcess)
			{
				return;
			}
			
			if(cardAnimateContainer.length > 0)
			{
				inProcess = true;
				visible = true;
				x = (GameManager.container.stageWidth - (cardAnimateContainer.length * cardAnimateContainer[0].width)) / 2;
				y = (GameManager.container.stageHeight - cardAnimateContainer[0].height) / 2;
				btnOk.x = (cardAnimateContainer.length * cardAnimateContainer[0].width - btnOk.width) / 2;
				
				var card: Card;
				var centerY: int;
				var delay: Number = 0;
				var targetX: int = 0;
				for(var i: int = 0; i<cardAnimateContainer.length; i++)
				{
					card = cardAnimateContainer[i];
					card.interactive = false;
					container.addChild(card);
					card.y = GameManager.container.stageHeight - y;
					TweenLite.to(card, .5, {x: targetX, y: 0, delay: delay, ease: Strong.easeOut, onComplete: onCardAnimateComplete, onCompleteParams: [card]});
					targetX += card.cardResourceBuffer.width;
					delay += .1;
				}
			}
		}
		
		private function onCardAnimateComplete(card: Card): void
		{
			card.interactive = true;
		}
		
		private function onBtnOkClick(evt: MouseEvent): void
		{
			inProcess = false;
			
			var card: Card;
			var delay: Number = 0;
			var targetY: int = GameManager.container.stageHeight - y;
			for(var i: int = 0; i<cardAnimateContainer.length; i++)
			{
				card = cardAnimateContainer[i];
				card.interactive = false;
				
				TweenLite.to(card, .5, {y: targetY, delay: delay, ease: Strong.easeIn, onComplete: onCardComplete, onCompleteParams: [card]});
				delay += .1;
			}
		}
		
		private function onCardComplete(card: Card): void
		{
			card.interactive = true;
			
			var index: int = cardAnimateContainer.indexOf(card);
			if(index >= 0)
			{
				cardAnimateContainer.splice(index, 1);
			}
			
			var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.CHOUPAI_EVENT);
			event.value = card;
			card.inRound = true;
			dispatchEvent(event);
			
			if(cardAnimateContainer.length == 0)
			{
				visible = false;
				event = new BattleGameEvent(BattleGameEvent.CHOUPAI_COMPLETE_EVENT);
				dispatchEvent(event);
			}
		}
	}
}