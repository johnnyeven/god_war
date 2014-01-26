package com.xgame.godwar.core.room.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_ChangeFormation;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_DeployComplete;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_FirstChouPai;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_InitRoomDataLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandby;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PhaseRoundStandbyConfirm;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_PlayerEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_RequestStartGame;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_Spell;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_StartDice;
	import com.xgame.godwar.common.commands.receiving.Receive_BattleRoom_StartGameTimer;
	import com.xgame.godwar.common.commands.receiving.Receive_Hall_RequestEnterRoomLogicServer;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_ChangeFormation;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_DeployComplete;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_PhaseRoundStandbyConfirm;
	import com.xgame.godwar.common.commands.sending.Send_BattleRoom_Spell;
	import com.xgame.godwar.common.commands.sending.Send_Hall_RequestEnterRoomLogicServer;
	import com.xgame.godwar.common.object.Card;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.object.Skill;
	import com.xgame.godwar.common.object.SoulCard;
	import com.xgame.godwar.common.parameters.card.CardContainerParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.core.general.mediators.TimerMediator;
	import com.xgame.godwar.core.general.proxy.CardProxy;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.room.mediators.BattleGameMediator;
	import com.xgame.godwar.core.room.mediators.BattlePhaseMediator;
	import com.xgame.godwar.core.room.views.BattleGameOtherRoleComponent;
	import com.xgame.godwar.core.room.views.GameDiceComponent;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BattleGameProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "BattleGameProxy";
		public var currentRoomId: int;
		public var player: Player;
		
		public function BattleGameProxy()
		{
			super(NAME, null);
			//进入房间失败（满员）
			CommandList.instance.bind(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER, Receive_Hall_RequestEnterRoomLogicServer);
			CommandCenter.instance.add(SocketContextConfig.HALL_REQUEST_ENTER_ROOM_LOGICSERVER, onRequestEnterRoomFailed);
			//进入新房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_INIT_ROOM_LOGICSERVER, Receive_BattleRoom_InitRoomDataLogicServer);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_INIT_ROOM_LOGICSERVER, onRequestEnterRoom);
			//玩家进入房间
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM_LOGICSERVER, Receive_BattleRoom_PlayerEnterRoomLogicServer);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_PLAYER_ENTER_ROOM_LOGICSERVER, onPlayerEnterRoom);
			//开始游戏倒计时
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_START_BATTLE_TIMER, Receive_BattleRoom_StartGameTimer);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_START_BATTLE_TIMER, onStartGameTimer);
			//开始游戏
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_REQUEST_START_BATTLE, Receive_BattleRoom_RequestStartGame);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_REQUEST_START_BATTLE, onStartGame);
			//第一次抽牌
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_FIRST_CHOUPAI, Receive_BattleRoom_FirstChouPai);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_FIRST_CHOUPAI, onFirstChouPai);
			//部署完毕
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_DEPLOY_COMPLETE, Receive_BattleRoom_DeployComplete);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_DEPLOY_COMPLETE, onDeployComplete);
			//掷骰子
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_START_DICE, Receive_BattleRoom_StartDice);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_START_DICE, onStartDice);
			//摸牌阶段开始摸牌
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_ROUND_STANDBY, Receive_BattleRoom_PhaseRoundStandby);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_ROUND_STANDBY, onPhaseRoundStandby);
			//摸牌阶段完成
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CONFIRM, Receive_BattleRoom_PhaseRoundStandbyConfirm);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CONFIRM, onPhaseRoundStandbyConfirm);
			//换牌上场
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CHANGE_FORMATION, Receive_BattleRoom_ChangeFormation);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CHANGE_FORMATION, onChangeFormation);
			//发动技能
			CommandList.instance.bind(SocketContextConfig.BATTLEROOM_ROUND_ACTION_SPELL, Receive_BattleRoom_Spell);
			CommandCenter.instance.add(SocketContextConfig.BATTLEROOM_ROUND_ACTION_SPELL, onSpell);
		}
		
		public function requestEnterRoom(): void
		{
			if(CommandCenter.instance.connected)
			{
				if(currentRoomId > 0)
				{
					var protocol: Send_Hall_RequestEnterRoomLogicServer = new Send_Hall_RequestEnterRoomLogicServer();
					protocol.roomId = currentRoomId;
					protocol.roomType = 0;
					
					CommandCenter.instance.send(protocol);
					facade.sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
				}
			}
		}
		
		private function onRequestEnterRoomFailed(protocol: Receive_Hall_RequestEnterRoomLogicServer): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
		}
		
		private function onRequestEnterRoom(protocol: Receive_BattleRoom_InitRoomDataLogicServer): void
		{
			facade.sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			
			var proxy: CardProxy = facade.retrieveProxy(CardProxy.NAME) as CardProxy;
			var parameter: CardContainerParameter = proxy.container;
			var cardIndex: Dictionary = proxy.soulCardIndex;
			
			var p: Player = new Player();
			p.guid = protocol.guid;
			p.accountId = protocol.accountId;
			p.level = protocol.level;
			p.name = protocol.name;
			p.group = protocol.playerGroup;
			p.heroCardId = protocol.heroCardId;
			p.soulCardCount = protocol.soulCardCount;
			p.supplyCardCount = protocol.supplyCardCount;
			
			var i: int;
			var index: int;
			var card: SoulCard;
			
			var soulCardList: Array = protocol.soulCardString.split(",");
			for(i = 0; i < soulCardList.length; i++)
			{
				if(cardIndex.hasOwnProperty(soulCardList[i]))
				{
					index = cardIndex[soulCardList[i]];
					card = parameter.soulCardList[index];
					p.addSoulCard(card);
				}
			}
			var supplyCardList: Array = protocol.supplyCardString.split(",")
			for(i = 0; i < supplyCardList.length; i++)
			{
				
			}
			
			player = p;
			facade.sendNotification(BattleGameMediator.DEFINE_PLAYER_NOTE, player);
			
			setData(protocol);
			facade.sendNotification(BattleGameMediator.SHOW_ROOM_DATA_NOTE, protocol);
		}
		
		private function onPlayerEnterRoom(protocol: Receive_BattleRoom_PlayerEnterRoomLogicServer): void
		{
			facade.sendNotification(BattleGameMediator.ADD_PLAYER_NOTE, protocol);
		}
		
		private function onStartGameTimer(protocol: Receive_BattleRoom_StartGameTimer): void
		{
			facade.sendNotification(TimerMediator.ADD_TIMER_NOTE, 3);
		}
		
		private function onStartGame(protocol: Receive_BattleRoom_RequestStartGame): void
		{
			facade.sendNotification(BattlePhaseMediator.ADD_PHASE_NOTE, 0);
		}
		
		private function onFirstChouPai(protocol: Receive_BattleRoom_FirstChouPai): void
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
						facade.sendNotification(BattleGameMediator.ADD_CARD_ANIMATE_NOTE, card);
					}
				}
				
				facade.sendNotification(BattleGameMediator.START_CARD_ANIMATE_NOTE);
			}
		}
		
		public function deployComplete(defenser: String, attacker1: String, attacker2: String, attacker3: String): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_BattleRoom_DeployComplete = new Send_BattleRoom_DeployComplete();
				protocol.defenser = defenser;
				protocol.attacker1 = attacker1;
				protocol.attacker2 = attacker2;
				protocol.attacker3 = attacker3;
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onDeployComplete(protocol: Receive_BattleRoom_DeployComplete): void
		{
			facade.sendNotification(BattleGameMediator.DEPLOY_COMPLETE_NOTE, protocol.guid);
		}
		
		private function onStartDice(protocol: Receive_BattleRoom_StartDice): void
		{
			facade.sendNotification(BattleGameMediator.START_DICE_NOTE, protocol.parameter);
		}
		
		private function onPhaseRoundStandby(protocol: Receive_BattleRoom_PhaseRoundStandby): void
		{
			facade.sendNotification(BattleGameMediator.PHASE_ROUND_STANDBY_NOTE, protocol);
			facade.sendNotification(BattlePhaseMediator.ADD_PHASE_NOTE, 2);
		}
		
		public function roundStandbyComplete(soulCount: int, supplyCount: int): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_BattleRoom_PhaseRoundStandbyConfirm = new Send_BattleRoom_PhaseRoundStandbyConfirm();
				protocol.soulCount = soulCount;
				protocol.supplyCount = supplyCount;
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onPhaseRoundStandbyConfirm(protocol: Receive_BattleRoom_PhaseRoundStandbyConfirm): void
		{
			facade.sendNotification(BattleGameMediator.PHASE_ROUND_STANDBY_COMPLETE_NOTE, protocol);
		}
		
		public function changeFormation(cardIn: String, cardOut: String): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_BattleRoom_ChangeFormation = new Send_BattleRoom_ChangeFormation();
				protocol.cardIn = cardIn;
				protocol.cardOut = cardOut;
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onChangeFormation(protocol: Receive_BattleRoom_ChangeFormation): void
		{
			facade.sendNotification(BattleGameMediator.PHASE_ROUND_STANDBY_CHANGE_FORMATION_NOTE, protocol);
		}
		
		public function spell(card: Card, skill: Skill, target: BattleGameOtherRoleComponent = null): void
		{
			if(CommandCenter.instance.connected)
			{
				var protocol: Send_BattleRoom_Spell = new Send_BattleRoom_Spell();
				protocol.attackerCard = card.id;
				protocol.skillId = skill.id;
				if(target != null)
				{
					protocol.defenderGuid = target.player.guid;
				}
				CommandCenter.instance.send(protocol);
			}
		}
		
		private function onSpell(protocol: Receive_BattleRoom_Spell): void
		{
			facade.sendNotification(BattleGameMediator.PHASE_ROUND_ACTION_SPELL_NOTE, protocol);
		}
	}
}