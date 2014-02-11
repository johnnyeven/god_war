package com.xgame.godwar.core.room.mediators
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_ChangeFormation;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandby;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandbyConfirm;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_Spell;
	import com.xgame.godwar.common.commands.receiving.Receive_Info_AccountRole;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.CardManager;
	import com.xgame.godwar.common.object.HeroCard;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.object.Skill;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.PlayerParameter;
	import com.xgame.godwar.common.parameters.card.CardContainerParameter;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.HeroCardParameterPool;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.core.GameManager;
	import com.xgame.godwar.core.center.EffectCenter;
	import com.xgame.godwar.core.center.ResourceCenter;
	import com.xgame.godwar.core.general.mediators.BaseMediator;
	import com.xgame.godwar.core.general.proxy.AvatarConfigProxy;
	import com.xgame.godwar.core.general.proxy.CardProxy;
	import com.xgame.godwar.core.login.proxy.RequestRoleProxy;
	import com.xgame.godwar.core.room.proxy.BattleGameProxy;
	import com.xgame.godwar.core.room.views.BattleGameCardFormationComponent;
	import com.xgame.godwar.core.room.views.BattleGameComponent;
	import com.xgame.godwar.core.room.views.BattleGameOtherRoleComponent;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	import com.xgame.godwar.core.room.views.SoulCardSkillComponent;
	import com.xgame.godwar.display.BitmapMovieDispaly;
	import com.xgame.godwar.display.renders.Render;
	import com.xgame.godwar.enum.AttackInfo;
	import com.xgame.godwar.events.BattleGameEvent;
	import com.xgame.godwar.events.CardEvent;
	import com.xgame.godwar.utils.StringUtils;
	import com.xgame.godwar.utils.UIUtils;
	import com.xgame.godwar.utils.manager.TimerManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	
	public class BattleGameMediator extends BaseMediator
	{
		public static const NAME: String = "BattleGameMediator";
		public static const SHOW_NOTE: String = NAME + ".ShowNote";
		public static const HIDE_NOTE: String = NAME + ".HideNote";
		public static const DISPOSE_NOTE: String = NAME + ".DisposeNote";
		public static const DEFINE_PLAYER_NOTE: String = NAME + ".DefinePlayerNote";
		public static const SHOW_ROOM_DATA_NOTE: String = NAME + ".ShowRoomDataNote";
		public static const ADD_PLAYER_NOTE: String = NAME + ".AddPlayerNote";
		public static const ADD_CARD_ANIMATE_NOTE: String = NAME + ".AddCardAnimateNote";
		public static const START_CARD_ANIMATE_NOTE: String = NAME + ".StartCardAnimateNote";
		public static const DEPLOY_COMPLETE_NOTE: String = NAME + ".DeployCompleteNote";
		public static const START_DICE_NOTE: String = NAME + ".StartDiceNote";
		public static const PHASE_ROUND_STANDBY_NOTE: String = NAME + ".PhaseRoundStandbyNote";
		public static const PHASE_ROUND_STANDBY_COMPLETE_NOTE: String = NAME + ".PhaseRoundStandbyCompleteNote";
		public static const PHASE_ROUND_STANDBY_CHANGE_FORMATION_NOTE: String = NAME + ".PhaseRoundStandbyChangeFormationNote";
		public static const PHASE_ROUND_ACTION_SPELL_NOTE: String = NAME + ".PhaseRoundActionSpellNote";
		
		private var _cardDefenser: String;
		private var _cardAttacker1: String;
		private var _cardAttacker2: String;
		private var _cardAttacker3: String;
		
		private var player: Player;
		
		public function BattleGameMediator()
		{
			super(NAME, new BattleGameComponent());
			
			component.mediator = this;
			
			component.addEventListener(BattleGameEvent.CHOUPAI_COMPLETE_EVENT, onChouPaiComplete);
			component.addEventListener(BattleGameEvent.FIGHT_EVENT, onFight);
			component.addEventListener(BattleGameEvent.ROUND_STANDBY_EVENT, onRoundStandby);
			component.addEventListener(CardEvent.FIGHT_CLICK, onCardFightClick);
			component.addEventListener(CardEvent.ATTACK_CLICK, onCardAttackClick);
			component.addEventListener(CardEvent.SPELL_CLICK, onCardSpellClick);
			
			EffectCenter.instance.start();
		}
		
		public function get component(): BattleGameComponent
		{
			return viewComponent as BattleGameComponent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [SHOW_NOTE, HIDE_NOTE, DISPOSE_NOTE, DEFINE_PLAYER_NOTE, SHOW_ROOM_DATA_NOTE, ADD_PLAYER_NOTE,
				ADD_CARD_ANIMATE_NOTE, START_CARD_ANIMATE_NOTE, DEPLOY_COMPLETE_NOTE, START_DICE_NOTE,
				PHASE_ROUND_STANDBY_NOTE, PHASE_ROUND_STANDBY_COMPLETE_NOTE,PHASE_ROUND_STANDBY_CHANGE_FORMATION_NOTE,
				PHASE_ROUND_ACTION_SPELL_NOTE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SHOW_NOTE:
					show();
					requestEnterRoom();
					break;
				case HIDE_NOTE:
					hide(function(): void
					{
						remove();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
				case DISPOSE_NOTE:
					hide(function(): void
					{
						dispose();
						var func: Function = notification.getBody() as Function;
						if(func != null)
						{
							func();
						}
					});
					break;
				case DEFINE_PLAYER_NOTE:
					player = notification.getBody() as Player;
					break;
				case SHOW_ROOM_DATA_NOTE:
					showRoomData(notification.getBody() as Receive_BattleRoom_InitRoomDataLogicServer);
					break;
				case ADD_PLAYER_NOTE:
					addPlayer(notification.getBody() as Receive_BattleRoom_PlayerEnterRoomLogicServer);
					break;
				case ADD_CARD_ANIMATE_NOTE:
					component.choupaiComponent.addCardAnimate(notification.getBody() as Card);
					break;
				case START_CARD_ANIMATE_NOTE:
					component.choupaiComponent.startCardAnimate();
					break;
				case DEPLOY_COMPLETE_NOTE:
					deployComplete(String(notification.getBody()));
					break;
				case START_DICE_NOTE:
					startDice(notification.getBody() as Dictionary);
					break;
				case PHASE_ROUND_STANDBY_NOTE:
					phaseRoundStandby((notification.getBody() as Receive_BattleRoom_PhaseRoundStandby).guid);
					break;
				case PHASE_ROUND_STANDBY_COMPLETE_NOTE:
					phaseRoundStandbyComplete(notification.getBody() as Receive_BattleRoom_PhaseRoundStandbyConfirm);
					break;
				case PHASE_ROUND_STANDBY_CHANGE_FORMATION_NOTE:
					changeFormation(notification.getBody() as Receive_BattleRoom_ChangeFormation);
					break;
				case PHASE_ROUND_ACTION_SPELL_NOTE:
					spell(notification.getBody() as Receive_BattleRoom_Spell);
					break;
			}
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(component, .5, { alpha: 0, ease: Strong.easeIn, onComplete: callback });
		}
		
		private function requestEnterRoom(): void
		{
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			proxy.requestEnterRoom();
		}
		
		private function showRoomData(protocol: Receive_BattleRoom_InitRoomDataLogicServer): void
		{
			component.peopleCount = protocol.peopleCount;
			component.playerGroup = protocol.playerGroup;
			component.initBattleArea();
			
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			var parameter: PlayerParameter;
			var roleComponent: BattleGameOtherRoleComponent;
			var player: Player;
			var heroParameter: HeroCardParameter;
			
			if(!StringUtils.empty(protocol.heroCardId))
			{
				heroParameter = HeroCardParameterPool.instance.get(protocol.heroCardId) as HeroCardParameter;
				component.panelComponent.mainRoleComponent.setMainRoleAvatar(heroParameter.avatarPathBig);
			}
			
			for(var i: int = 0; i<protocol.playerList.length; i++)
			{
				parameter = protocol.playerList[i];
				
				player = new Player();
				player.guid = parameter.guid;
				player.accountId = parameter.accountId;
				player.name = parameter.name;
				player.level = parameter.level;
				player.avatarId = parameter.avatarId;
				player.heroCardId = parameter.heroCardId;
				player.cash = parameter.cash;
				player.winningCount = parameter.winningCount;
				player.battleCount = parameter.battleCount;
				player.honor = parameter.honor;
				player.group = parameter.group;
				
				if(!StringUtils.empty(parameter.heroCardId))
				{
					heroParameter = HeroCardParameterPool.instance.get(parameter.heroCardId) as HeroCardParameter;
					player.heroCardPath = heroParameter.avatarPathBig;
				}
				
				roleComponent = new BattleGameOtherRoleComponent();
				roleComponent.player = player;
				
				component.addPlayer(roleComponent);
			}
		}
		
		private function addPlayer(protocol: Receive_BattleRoom_PlayerEnterRoomLogicServer): void
		{
			var proxy: AvatarConfigProxy = facade.retrieveProxy(AvatarConfigProxy.NAME) as AvatarConfigProxy;
			
			var player: Player = new Player();
			player.guid = protocol.guid;
			player.accountId = protocol.accountId;
			player.name = protocol.name;
			player.level = protocol.level;
			player.heroCardId = protocol.heroCardId;
			player.group = protocol.group;
			
			if(!StringUtils.empty(protocol.heroCardId))
			{
				var heroParameter: HeroCardParameter = HeroCardParameterPool.instance.get(protocol.heroCardId) as HeroCardParameter;
				player.heroCardPath = heroParameter.avatarPathBig;
			}
			
			var roleComponent: BattleGameOtherRoleComponent = new BattleGameOtherRoleComponent();
			roleComponent.player = player;
			
			component.addPlayer(roleComponent);
		}
		
		private function onChouPaiComplete(evt: BattleGameEvent): void
		{
			facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "请选择出四张英灵牌放置在阵形位置");
			facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
		}
		
		private function onFight(evt: BattleGameEvent): void
		{
			facade.sendNotification(BattleGuideMediator.HIDE_NOTE);
			component.panelComponent.btnFightEnabled(false);
			
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			proxy.deployComplete(_cardDefenser, _cardAttacker1, _cardAttacker2, _cardAttacker3);
			
			if(component.panelComponent.cardFormation.soulCard0 != null)
			{
				component.panelComponent.cardFormation.soulCard0.inRound = false;
				component.panelComponent.cardFormation.soulCard0.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
			}
			if(component.panelComponent.cardFormation.soulCard1 != null)
			{
				component.panelComponent.cardFormation.soulCard1.inRound = false;
				component.panelComponent.cardFormation.soulCard1.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
			}
			if(component.panelComponent.cardFormation.soulCard2 != null)
			{
				component.panelComponent.cardFormation.soulCard2.inRound = false;
				component.panelComponent.cardFormation.soulCard2.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
			}
			if(component.panelComponent.cardFormation.soulCard3 != null)
			{
				component.panelComponent.cardFormation.soulCard3.inRound = false;
				component.panelComponent.cardFormation.soulCard3.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
			}
			var handList: Vector.<Card> = player.cardHandList;
			for(var i: int = 0; i<handList.length; i++)
			{
				handList[i].inRound = false;
			}
		}
		
		private function deployComplete(guid: String): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == guid)
					{
						
					}
					else
					{
						component.setOtherRoleDeployComplete(guid);
					}
				}
			}
		}
		
		private function startDice(parameter: Dictionary): void
		{
			var componentIndex: Dictionary = component.componentIndex;
			var otherRoleComponent: BattleGameOtherRoleComponent;
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					for(var guid: String in parameter)
					{
						if(protocolRole.guid == guid)
						{
							component.panelComponent.mainRoleComponent.startDice(int(parameter[guid]));
						}
						else
						{
							otherRoleComponent = componentIndex[guid];
							if(otherRoleComponent != null)
							{
								otherRoleComponent.startDice(int(parameter[guid]));
							}
						}
					}
					
					TimerManager.instance.add(5000, clearDice);
				}
			}
		}
		
		private function clearDice(): void
		{
			var otherRoleComponent: BattleGameOtherRoleComponent;
			var componentIndex: Dictionary = component.componentIndex;
			
			for each(otherRoleComponent in componentIndex)
			{
				otherRoleComponent.removeDice();
			}
			component.panelComponent.mainRoleComponent.removeDice();
			
			TimerManager.instance.remove(clearDice);
		}
		
		private function phaseRoundStandby(guid: String): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole != null)
				{
					if(protocolRole.guid == guid)
					{
						component.paiduiComponent.visible = true;
						
						if(component.panelComponent.cardFormation.soulCard0 != null)
						{
							component.panelComponent.cardFormation.soulCard0.inRound = true;
							component.panelComponent.cardFormation.soulCard0.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
						}
						if(component.panelComponent.cardFormation.soulCard1 != null)
						{
							component.panelComponent.cardFormation.soulCard1.inRound = true;
							component.panelComponent.cardFormation.soulCard1.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
						}
						if(component.panelComponent.cardFormation.soulCard2 != null)
						{
							component.panelComponent.cardFormation.soulCard2.inRound = true;
							component.panelComponent.cardFormation.soulCard2.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
						}
						if(component.panelComponent.cardFormation.soulCard3 != null)
						{
							component.panelComponent.cardFormation.soulCard3.inRound = true;
							component.panelComponent.cardFormation.soulCard3.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
						}
						var handList: Vector.<Card> = player.cardHandList;
						for(var i: int = 0; i<handList.length; i++)
						{
							handList[i].inRound = true;
						}
					}
					else
					{
						var componentIndex: Dictionary = component.componentIndex;
						var otherRoleComponent: BattleGameOtherRoleComponent;
						otherRoleComponent = componentIndex[guid];
						if(otherRoleComponent != null)
						{
							
						}
					}
				}
			}
		}
		
		private function onRoundStandby(evt: BattleGameEvent): void
		{
			var tmp: Array = evt.value as Array;
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			if(tmp != null && proxy != null)
			{
				proxy.roundStandbyComplete(tmp[0], tmp[1]);
			}
		}
		
		private function phaseRoundStandbyComplete(protocol: Receive_BattleRoom_PhaseRoundStandbyConfirm): void
		{
			if(protocol != null)
			{
				var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
				if(cardProxy != null)
				{
					var parameter: CardContainerParameter = cardProxy.container;
					var cardIndex: Dictionary = cardProxy.soulCardIndex;
					var index: int;
					var card: SoulCard;
					
					for(var i: int = 0; i < protocol.soulCardList.length; i++)
					{
						if(cardIndex.hasOwnProperty(protocol.soulCardList[i]))
						{
							index = cardIndex[protocol.soulCardList[i]];
							card = parameter.soulCardList[index];
							player.removeSoulCard(card);
							player.addCardHand(card);
							component.paiduiComponent.addCard(card);
						}
					}
					component.paiduiComponent.showCards();
				}
			}
		}
		
		private function onCardAttackClick(evt: CardEvent): void
		{
			
		}
		
		private function onCardSpellClick(evt: CardEvent): void
		{
			var skillComponent: SoulCardSkillComponent = evt.value as SoulCardSkillComponent;
			var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
			var skill: Skill = skillComponent.skill;
			var card: SoulCard = skillComponent.card;
			var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
			CardManager.instance.currentSelectedSkill = skill;
			
			for(var i: int = 0; i<card.skillList.length; i++)
			{
				card.skillList[i].visible = false;
			}
			if(skill.target == "me")
			{
				proxy.spell(card, skill);
			}
			else if(skill.target == "enemy")
			{
				var list: Vector.<BattleGameOtherRoleComponent> = component.componentList;
				var item: BattleGameOtherRoleComponent;
				for(i = 0; i<list.length; i++)
				{
					item = list[i];
					if(item.player.group != player.group)
					{
						item.addEventListener(MouseEvent.CLICK, onCardSkillTargetClick);
					}
				}
			}
		}
		
		private function onCardSkillTargetClick(evt: MouseEvent): void
		{
			evt.stopImmediatePropagation();
			var list: Vector.<BattleGameOtherRoleComponent> = component.componentList;
			for(var i: int = 0; i<list.length; i++)
			{
				list[i].removeEventListener(MouseEvent.CLICK, onCardSkillTargetClick);
			}
			
			var target: BattleGameOtherRoleComponent = evt.currentTarget as BattleGameOtherRoleComponent;
			if(target != null)
			{
				var proxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
				proxy.spell(CardManager.instance.currentSelectedCard, CardManager.instance.currentSelectedSkill, target);
			}
			var card: Card = CardManager.instance.currentSelectedCard;
			
			card.cardController.x = -card.cardResourceBuffer.width;;
			card.cardController.visible = false;
			card.cancelSelect();
		}
		
		private function onCardFightClick(evt: CardEvent): void
		{
			var card: SoulCard = evt.value as SoulCard;
			CardManager.instance.currentFightCard = card;
			var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
			var bitmapMovie: BitmapMovieDispaly;
			if(formationComponent.soulCard0 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("highlight1");
				formationComponent.card0.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard1 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("highlight1");
				formationComponent.card1.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard2 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("highlight1");
				formationComponent.card2.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			if(formationComponent.soulCard3 == null)
			{
				bitmapMovie = EffectCenter.instance.getEffect("highlight1");
				formationComponent.card3.addChild(bitmapMovie);
				EffectCenter.instance.addEffect(bitmapMovie);
			}
			
			if(!formationComponent.card0.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card0.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card1.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card1.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card2.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card2.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
			if(!formationComponent.card3.hasEventListener(MouseEvent.CLICK))
			{
				formationComponent.card3.addEventListener(MouseEvent.CLICK, onCardFormationClick);
			}
		}
		
		private function onCardFormationClick(evt: MouseEvent): void
		{
			var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
			var card: MovieClip = evt.currentTarget as MovieClip;
			card.removeEventListener(MouseEvent.CLICK, onCardFormationClick);
			
			var current: SoulCard = CardManager.instance.currentFightCard as SoulCard;
			if(current != null)
			{
				if(card == formationComponent.card0)
				{
					component.panelComponent.removeCard(current);
					formationComponent.setCard(0, current);
					_cardDefenser = current.id;
				}
				else if(card == formationComponent.card1)
				{
					component.panelComponent.removeCard(current);
					formationComponent.setCard(1, current);
					_cardAttacker1 = current.id;
				}
				else if(card == formationComponent.card2)
				{
					component.panelComponent.removeCard(current);
					formationComponent.setCard(2, current);
					_cardAttacker2 = current.id;
				}
				else if(card == formationComponent.card3)
				{
					component.panelComponent.removeCard(current);
					formationComponent.setCard(3, current);
					_cardAttacker3 = current.id;
				}
				player.removeHandCard(current);
				CardManager.instance.currentSelectedCard = null;
				
				if(formationComponent.soulCard0 != null &&
					formationComponent.soulCard1 != null &&
					formationComponent.soulCard2 != null &&
					formationComponent.soulCard3 != null)
				{
					facade.sendNotification(BattleGuideMediator.CHANGE_CONTENT_NOTE, "部署完毕，点击“开始战斗”按钮！");
					facade.sendNotification(BattleGuideMediator.SHOW_NOTE);
					component.panelComponent.btnFightEnabled(true);
				}
			}
		}
		
		private function onCardFormationChange(evt: MouseEvent): void
		{
			var currentCard: SoulCard = CardManager.instance.currentFightCard;
			if(currentCard != null)
			{
				evt.stopImmediatePropagation();
				var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
				var card: SoulCard = evt.currentTarget as SoulCard;
				
				if(currentCard.level > 3)
				{
					
				}
				else
				{
					var gameProxy: BattleGameProxy = facade.retrieveProxy(BattleGameProxy.NAME) as BattleGameProxy;
					gameProxy.changeFormation(currentCard.id, card.id);
				}
			}
		}
		
		private function changeFormation(protocol: Receive_BattleRoom_ChangeFormation): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var roleProtocol: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(roleProtocol != null && protocol != null)
				{
					if(roleProtocol.guid == protocol.guid)
					{
						var currentCard: SoulCard = CardManager.instance.currentFightCard;
						if((currentCard != null && currentCard.id != protocol.cardIn) || currentCard == null)
						{
							for(var i: int = 0; i<player.cardHandList.length; i++)
							{
								if(player.cardHandList[i].id == protocol.cardIn)
								{
									currentCard == player.cardHandList[i];
									break;
								}
							}
						}
						if(currentCard != null)
						{
							var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
							var card: SoulCard;
							
							component.panelComponent.removeCard(currentCard);
							player.removeHandCard(currentCard);
							
							if(formationComponent.soulCard0.id == protocol.cardOut)
							{
								card = formationComponent.soulCard0;
								formationComponent.removeCard(0);
								formationComponent.setCard(0, currentCard);
							}
							else if(formationComponent.soulCard1.id == protocol.cardOut)
							{
								card = formationComponent.soulCard1;
								formationComponent.removeCard(1);
								formationComponent.setCard(1, currentCard);
							}
							else if(formationComponent.soulCard2.id == protocol.cardOut)
							{
								card = formationComponent.soulCard2;
								formationComponent.removeCard(2);
								formationComponent.setCard(2, currentCard);
							}
							else if(formationComponent.soulCard3.id == protocol.cardOut)
							{
								card = formationComponent.soulCard3;
								formationComponent.removeCard(3);
								formationComponent.setCard(3, currentCard);
							}
							currentCard.addEventListener(MouseEvent.CLICK, onCardFormationChange, false, 100);
							
							if(card.isBack)
							{
								player.addCardHand(card);
								component.panelComponent.addCard(card);
							}
							else
							{
								player.addCardGrave(card);
							}
							
							currentCard.cancelSelect();
						}
					}
					else
					{
						var componentIndex: Dictionary = component.componentIndex;
						var otherRoleComponent: BattleGameOtherRoleComponent;
						otherRoleComponent = componentIndex[protocol.guid];
						if(otherRoleComponent != null)
						{
							
						}
					}
				}
			}
		}
		
		private function spell(protocol: Receive_BattleRoom_Spell): void
		{
			if(protocol != null && protocol.attackInfo.length > 0)
			{
				var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
				if(roleProxy != null)
				{
					var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
					if(protocolRole == null)
					{
						return;
					}
				}
				var info: AttackInfo;
				var soulCard: SoulCard;
				var heroCard: HeroCard;
				var skillEffect: BitmapMovieDispaly;
				var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
				var componentIndex: Dictionary;
				var componentList: Vector.<BattleGameOtherRoleComponent>;
				var otherComponent: BattleGameOtherRoleComponent;
				var backCard: Sprite;
				var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
				var soulCardList: Array = cardProxy.container.soulCardList;
				var soulCardIndex: Dictionary = cardProxy.soulCardIndex;
				for(var i: int = 0; i<protocol.attackInfo.length; i++)
				{
					info = protocol.attackInfo[i];
					if(!StringUtils.empty(info.skillId))
					{
						if(!StringUtils.empty(info.attackerGuid) && !StringUtils.empty(info.attackerCard))
						{
							if(protocolRole.guid == info.attackerGuid)
							{
								soulCard = formationComponent.getCard(info.attackerCard);
								if(soulCard != null)
								{
									skillEffect = EffectCenter.instance.getEffect(info.skillId);
									skillEffect.loop = false;
									soulCard.addEffect(skillEffect);
									EffectCenter.instance.addEffect(skillEffect, spell2, [info]);
								}
								else
								{
									//TODO 英雄卡牌
								}
							}
							else
							{
								componentIndex = component.componentIndex;
								if(componentIndex.hasOwnProperty(info.attackerGuid))
								{
									otherComponent = componentIndex[info.attackerGuid];
									soulCard = otherComponent.cardContainer.getCard(info.attackerCard);
									skillEffect = EffectCenter.instance.getEffect(info.skillId);
									skillEffect.loop = false;
									if(soulCard != null)
									{
										skillEffect.width = soulCard.cardResourceBuffer.width;
										skillEffect.height = soulCard.cardResourceBuffer.height;
										soulCard.addEffect(skillEffect);
									}
									else
									{
										backCard = otherComponent.cardContainer.getBack(info.attackerCardPosition);
										if(backCard != null)
										{
											if(info.attackCardUp)
											{
												backCard.visible = false;
												if(soulCardIndex != null && soulCardIndex.hasOwnProperty(info.attackerCard))
												{
													soulCard = soulCardList[soulCardIndex[info.attackerCard]] as SoulCard;
													if(soulCard != null)
													{
														soulCard = soulCard.clone() as SoulCard;
														otherComponent.cardContainer.addCard(info.attackerCardPosition, soulCard, function(): void
														{
//															skillEffect.width = soulCard.cardResourceBuffer.width;
//															skillEffect.height = soulCard.cardResourceBuffer.height;
															soulCard.addEffect(skillEffect);
														});
													}
												}
											}
											else
											{
												skillEffect.width = backCard.width;
												skillEffect.height = backCard.height;
												backCard.addChild(skillEffect);
											}
										}
									}
									EffectCenter.instance.addEffect(skillEffect, spell2, [info]);
								}
							}
						}
//						if(!StringUtils.empty(info.defenderGuid) && !StringUtils.empty(info.defenderCard))
//						{
//							if(protocolRole.guid == info.defenderGuid)
//							{
//								soulCard = formationComponent.getCard(info.defenderCard);
//								if(soulCard != null)
//								{
//									skillEffect = EffectCenter.instance.getEffect(info.skillId + "_underattack");
//									skillEffect.loop = false;
//									soulCard.addEffect(skillEffect);
//									EffectCenter.instance.addEffect(skillEffect);
//								}
//								else
//								{
//									//TODO 英雄卡牌
//								}
//							}
//							else
//							{
//								componentIndex = component.componentIndex;
//								if(componentIndex.hasOwnProperty(info.defenderGuid))
//								{
//									otherComponent = componentIndex[info.defenderGuid];
//									soulCard = otherComponent.cardContainer.getCard(info.defenderCard);
//									skillEffect = EffectCenter.instance.getEffect(info.skillId + "_underattack");
//									skillEffect.loop = false;
//									if(soulCard != null)
//									{
//										skillEffect.width = soulCard.cardResourceBuffer.width;
//										skillEffect.height = soulCard.cardResourceBuffer.height;
//										soulCard.addEffect(skillEffect);
//									}
//									else
//									{
//										backCard = otherComponent.cardContainer.getBack(info.defenderCardPosition);
//										if(backCard != null)
//										{
//											if(info.defenderCardUp)
//											{
//												backCard.visible = false;
//												if(soulCardIndex != null && soulCardIndex.hasOwnProperty(info.defenderCard))
//												{
//													soulCard = soulCardList[soulCardIndex[info.defenderCard]] as SoulCard;
//													if(soulCard != null)
//													{
//														soulCard = soulCard.clone() as SoulCard;
//														otherComponent.cardContainer.addCard(info.defenderCardPosition, soulCard, function(): void
//														{
//															skillEffect.width = soulCard.cardResourceBuffer.width;
//															skillEffect.height = soulCard.cardResourceBuffer.height;
//															soulCard.addEffect(skillEffect);
//														});
//													}
//												}
//											}
//											else
//											{
//												skillEffect.width = backCard.width;
//												skillEffect.height = backCard.height;
//												backCard.addChild(skillEffect);
//											}
//										}
//									}
//									EffectCenter.instance.addEffect(skillEffect);
//								}
//							}
//						}
					}
				}
			}
		}
		
		private function spell2(info: AttackInfo): void
		{
			var roleProxy: RequestRoleProxy = facade.retrieveProxy(RequestRoleProxy.NAME) as RequestRoleProxy;
			if(roleProxy != null)
			{
				var protocolRole: Receive_Info_AccountRole = roleProxy.getData() as Receive_Info_AccountRole;
				if(protocolRole == null)
				{
					return;
				}
			}
			var soulCard: SoulCard;
			var skillEffect: BitmapMovieDispaly;
			var formationComponent: BattleGameCardFormationComponent = component.panelComponent.cardFormation;
			var componentIndex: Dictionary;
			var otherComponent: BattleGameOtherRoleComponent;
			var backCard: Sprite;
			var cardProxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
			var soulCardList: Array = cardProxy.container.soulCardList;
			var soulCardIndex: Dictionary = cardProxy.soulCardIndex;
			
			if(!StringUtils.empty(info.defenderGuid) && !StringUtils.empty(info.defenderCard))
			{
				if(protocolRole.guid == info.defenderGuid)
				{
					soulCard = formationComponent.getCard(info.defenderCard);
					if(soulCard != null)
					{
						skillEffect = EffectCenter.instance.getEffect(info.skillId + "_underattack");
						skillEffect.loop = false;
						soulCard.addEffect(skillEffect);
						EffectCenter.instance.addEffect(skillEffect);
					}
					else
					{
						//TODO 英雄卡牌
					}
				}
				else
				{
					componentIndex = component.componentIndex;
					if(componentIndex.hasOwnProperty(info.defenderGuid))
					{
						otherComponent = componentIndex[info.defenderGuid];
						soulCard = otherComponent.cardContainer.getCard(info.defenderCard);
						skillEffect = EffectCenter.instance.getEffect(info.skillId + "_underattack");
						skillEffect.loop = false;
						if(soulCard != null)
						{
							skillEffect.width = soulCard.cardResourceBuffer.width;
							skillEffect.height = soulCard.cardResourceBuffer.height;
							soulCard.addEffect(skillEffect);
						}
						else
						{
							backCard = otherComponent.cardContainer.getBack(info.defenderCardPosition);
							if(backCard != null)
							{
								if(info.defenderCardUp)
								{
									backCard.visible = false;
									if(soulCardIndex != null && soulCardIndex.hasOwnProperty(info.defenderCard))
									{
										soulCard = soulCardList[soulCardIndex[info.defenderCard]] as SoulCard;
										if(soulCard != null)
										{
											soulCard = soulCard.clone() as SoulCard;
											otherComponent.cardContainer.addCard(info.defenderCardPosition, soulCard, function(): void
											{
												skillEffect.width = soulCard.cardResourceBuffer.width;
												skillEffect.height = soulCard.cardResourceBuffer.height;
												soulCard.addEffect(skillEffect);
											});
										}
									}
								}
								else
								{
									skillEffect.width = backCard.width;
									skillEffect.height = backCard.height;
									backCard.addChild(skillEffect);
								}
							}
						}
						EffectCenter.instance.addEffect(skillEffect);
					}
				}
			}
		}
	}
}