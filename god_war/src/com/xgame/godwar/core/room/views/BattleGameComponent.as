package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.FlowLayout;
	import com.xgame.godwar.utils.UIUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
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
		private var _componentList: Vector.<BattleGameOtherRoleComponent>;
		private var _componentIndex: Dictionary;
		private var myGroupContainer: Container;
		private var otherGroupContainer: Container;
		private var _choupaiComponent: BattleGameChouPaiComponent;
		private var _paiduiComponent: GamePaiduiContainerComponent;
		
		private var deployPhase: int = 0;
		
		private var _cardDefenser: String;
		private var _cardAttacker1: String;
		private var _cardAttacker2: String;
		private var _cardAttacker3: String;
		
		public function BattleGameComponent(_skin:DisplayObjectContainer=null)
		{
			super(_skin ? _skin : ResourcePool.instance.getDisplayObject("assets.ui.room.BattleGameComponent", null, false) as DisplayObjectContainer);
			
			myGroupContainer = getUI(Container, "myGroupContainer") as Container;
			otherGroupContainer = getUI(Container, "otherGroupContainer") as Container;
			lblZhenxing = getUI(Label, "lblZhenxing") as Label;
			chatComponent = getUI(BattleGameChatComponent, "chatComponent") as BattleGameChatComponent;
			_panelComponent = getUI(BattleGamePanalComponent, "panelComponent") as BattleGamePanalComponent;
			_choupaiComponent = new BattleGameChouPaiComponent();
			GameManager.instance.addView(_choupaiComponent);
			_choupaiComponent.visible = false;
			_paiduiComponent = new GamePaiduiContainerComponent();
			UIUtils.center(_paiduiComponent);
			GameManager.instance.addView(_paiduiComponent);
			_paiduiComponent.visible = false;
			
			sortChildIndex();
			
			myGroupContainer.layout = new FlowLayout(myGroupContainer);
			myGroupContainer.layout.hGap = 0;
			myGroupContainer.layout.vGap = 0;
			
			otherGroupContainer.layout = new FlowLayout(otherGroupContainer);
			otherGroupContainer.layout.hGap = 0;
			otherGroupContainer.layout.vGap = 0;
			
			_componentList = new Vector.<BattleGameOtherRoleComponent>();
			_componentIndex = new Dictionary();
			_choupaiComponent.addEventListener(BattleGameEvent.CHOUPAI_EVENT, onChouPai);
			_choupaiComponent.addEventListener(BattleGameEvent.CHOUPAI_COMPLETE_EVENT, onChouPaiComplete);
			_paiduiComponent.addEventListener(BattleGameEvent.ROUND_STANDBY_EVENT, onRoundStandby);
			_paiduiComponent.addEventListener(BattleGameEvent.CHOUPAI_EVENT, onChouPai);
		}
		
		private function onChouPai(evt: BattleGameEvent): void
		{
			var card: Card = evt.value as Card;
			
			if(card.hasEventListener(MouseEvent.CLICK))
			{
				card.removeEventListenerType(MouseEvent.CLICK);
			}
			card.addEventListener(MouseEvent.CLICK, onHandCardClick);
			if(card != null)
			{
				_panelComponent.addCard(card);
			}
		}
		
		private function onRoundStandby(evt: BattleGameEvent): void
		{
			var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.ROUND_STANDBY_EVENT);
			event.value = evt.value;
			dispatchEvent(event);
		}
		
		private function onHandCardClick(evt: MouseEvent): void
		{
			if(deployPhase > 0 && deployPhase < 5)
			{
				var card: Card = evt.currentTarget as Card;
				card.removeEventListenerType(MouseEvent.CLICK);
				_panelComponent.removeCard(card);
				setCardFormation(deployPhase - 1, card as SoulCard);
				
				if(deployPhase == 1)
				{
					_cardDefenser = card.id;
				}
				else if(deployPhase == 2)
				{
					_cardAttacker1 = card.id;
				}
				else if(deployPhase == 3)
				{
					_cardAttacker2 = card.id;
				}
				else if(deployPhase == 4)
				{
					_cardAttacker3 = card.id;
				}
					
				deployPhase++;
				
				var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.DEPLOY_PHASE_EVENT);
				event.value = deployPhase;
				dispatchEvent(event);
			}
		}
		
		private function onChouPaiComplete(evt: BattleGameEvent): void
		{
			var event: BattleGameEvent = new BattleGameEvent(BattleGameEvent.CHOUPAI_COMPLETE_EVENT);
			dispatchEvent(event);
			deployPhase = 1;
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
			if(_componentList.indexOf(component) >= 0)
			{
				return;
			}
			_componentList.push(component);
			_componentIndex[component.player.guid] = component;
			
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
		
		override public function dispose():void
		{
			GameManager.instance.removeView(_choupaiComponent);
			_choupaiComponent.dispose();
			_choupaiComponent = null;
			
			GameManager.instance.removeView(_paiduiComponent);
			_paiduiComponent.dispose();
			_paiduiComponent = null;
			
			super.dispose();
		}

		public function get choupaiComponent():BattleGameChouPaiComponent
		{
			return _choupaiComponent;
		}
		
		public function get paiduiComponent(): GamePaiduiContainerComponent
		{
			return _paiduiComponent;
		}

		public function setCardFormation(position: int, card: SoulCard): void
		{
			panelComponent.cardFormation.setCard(position, card);
		}
		
		public function setOtherRoleDeployComplete(guid: String): void
		{
			var role: BattleGameOtherRoleComponent;
			for(var i: int = 0; i<_componentList.length; i++)
			{
				role = _componentList[i];
				if(role.player.guid == guid)
				{
					role.setDeploy(true);
					role.cardContainer.addCardBack(0);
					role.cardContainer.addCardBack(1);
					role.cardContainer.addCardBack(2);
					role.cardContainer.addCardBack(3);
					break;
				}
			}
		}

		public function get cardDefenser():String
		{
			return _cardDefenser;
		}

		public function get cardAttacker1():String
		{
			return _cardAttacker1;
		}

		public function get cardAttacker2():String
		{
			return _cardAttacker2;
		}

		public function get cardAttacker3():String
		{
			return _cardAttacker3;
		}

		public function get componentList():Vector.<BattleGameOtherRoleComponent>
		{
			return _componentList;
		}

		public function get componentIndex():Dictionary
		{
			return _componentIndex;
		}


	}
}