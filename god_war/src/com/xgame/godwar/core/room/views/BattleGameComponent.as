package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.FlowLayout;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	
	public class BattleGameComponent extends Component
	{
		public static const OTHER_GROUP_Y: int = 0;
		public static const MY_GROUP_Y: int = 265;
		public static const GROUP_WIDTH: int = 784;
		public static const CARD_WIDTH: int = 156;
		
		public static var OTHER_GROUP_X: int = 0;
		public static var MY_GROUP_X: int = 0;
		public static var MY_CARD_WIDTH: int = 155;
		public static var OTHER_CARD_WIDTH: int = 155;
		
		public var peopleCount: int = 0;
		public var playerGroup: int = 0;
		
		private var myStartX: int;
		private var otherStartX: int;
		private var lblZhenxing: Label;
		private var chatComponent: BattleGameChatComponent;
		private var _panelComponent: BattleGamePanalComponent;
		private var componentList: Vector.<BattleGameOtherRoleComponent>;
		private var myGroupContainer: Container;
		private var otherGroupContainer: Container;
		private var cardAnimateContainer: Vector.<Card>;
		
		public function BattleGameComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameComponent", null, false) as DisplayObjectContainer);
			
			myGroupContainer = getUI(Container, "myGroupContainer") as Container;
			otherGroupContainer = getUI(Container, "otherGroupContainer") as Container;
			lblZhenxing = getUI(Label, "lblZhenxing") as Label;
			chatComponent = getUI(BattleGameChatComponent, "chatComponent") as BattleGameChatComponent;
			_panelComponent = getUI(BattleGamePanalComponent, "panelComponent") as BattleGamePanalComponent;
			
			sortChildIndex();
			
			myGroupContainer.layout = new FlowLayout(myGroupContainer);
			myGroupContainer.layout.hGap = 0;
			myGroupContainer.layout.vGap = 0;
			
			otherGroupContainer.layout = new FlowLayout(otherGroupContainer);
			otherGroupContainer.layout.hGap = 0;
			otherGroupContainer.layout.vGap = 0;
			
			componentList = new Vector.<BattleGameOtherRoleComponent>();
			cardAnimateContainer = new Vector.<Card>();
		}
		
		public function addCardAnimate(card: Card): void
		{
			cardAnimateContainer.push(card);
		}
		
		public function startCardAnimate(): void
		{
			if(cardAnimateContainer.length > 0)
			{
				var card: Card;
				var centerY: int;
				var delay: Number = 0;
				var targetX: int = (GameManager.container.stageWidth - (cardAnimateContainer.length * cardAnimateContainer[0].width)) / 2;
				for(var i: int = 0; i<cardAnimateContainer.length; i++)
				{
					card = cardAnimateContainer[i];
					GameManager.instance.addView(card);
					UIUtils.center(card);
					centerY = card.y;
					card.y = 600;
					TweenLite.to(card, .5, {x: targetX, y: centerY, delay: delay, ease: Strong.easeOut});
					targetX += card.width;
					delay += .2;
				}
				cardAnimateContainer.splice(0, cardAnimateContainer.length);
			}
		}
		
		public function initBattleArea(): void
		{
			if(peopleCount >= 2)
			{
				var i: int = peopleCount / 2;
				OTHER_GROUP_X = (GROUP_WIDTH / (i+1)) - CARD_WIDTH / 2;
				
				if(i > 1)
				{
					MY_GROUP_X = (GROUP_WIDTH / i) - CARD_WIDTH / 2;
				}
				
				myStartX = MY_GROUP_X;
				otherStartX = OTHER_GROUP_X;
			}
		}
		
		public function addPlayer(component: BattleGameOtherRoleComponent): void
		{
			if(componentList.indexOf(component) >= 0)
			{
				return;
			}
			componentList.push(component);
			
			if(component.player.group == playerGroup)
			{
				component.switchHealthBar(true);
				myStartX += MY_GROUP_X;
				myGroupContainer.add(component);
				myGroupContainer.layout.update();
			}
			else
			{
				component.switchHealthBar(false);
				otherStartX += OTHER_GROUP_X;
				otherGroupContainer.add(component);
				otherGroupContainer.layout.update();
			}
		}

		public function get panelComponent():BattleGamePanalComponent
		{
			return _panelComponent;
		}

	}
}