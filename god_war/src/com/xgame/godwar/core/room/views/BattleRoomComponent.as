package com.xgame.godwar.core.room.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.xgame.godwar.common.object.Player;
	import com.xgame.godwar.common.parameters.card.HeroCardParameter;
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.enum.ScrollBarOrientation;
	import com.xgame.godwar.events.BattleRoomEvent;
	import com.xgame.godwar.liteui.component.CaptionButton;
	import com.xgame.godwar.liteui.component.Container;
	import com.xgame.godwar.liteui.component.Label;
	import com.xgame.godwar.liteui.component.ScrollBar;
	import com.xgame.godwar.liteui.core.Component;
	import com.xgame.godwar.liteui.layouts.FlowLayout;
	import com.xgame.godwar.liteui.layouts.HorizontalTileLayout;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class BattleRoomComponent extends Component
	{
		private var lblTitle: Label;
		private var btnCardConfig: CaptionButton;
		private var _btnReady: CaptionButton;
		private var heroList: Container;
		private var heroListScroll: ScrollBar;
		private var groupContainer1: Container;
		private var groupContainer2: Container;
		private var group1: Vector.<Player>;
		private var group2: Vector.<Player>;
		private var playerList: Vector.<Player>;
		private var componentList: Vector.<BattleRoomPlayerComponent>;
		private var _heroComponentList: Vector.<BattleRoomHeroComponent>;
		private var _heroComponentIndex: Dictionary;
		private var _ready: Boolean = false;
		public var currentGroup: int;
		public var isOwner: Boolean = false;
		
		public function BattleRoomComponent()
		{
			super(ResourcePool.instance.getDisplayObject("assets.ui.room.BattleRoomComponent", null, false) as DisplayObjectContainer);
			
			lblTitle = getUI(Label, "lblTitle") as Label;
			btnCardConfig = getUI(CaptionButton, "btnCardConfig") as CaptionButton;
			_btnReady = getUI(CaptionButton, "btnReady") as CaptionButton;
			heroList = getUI(Container, "lstContainer") as Container;
			groupContainer1 = getUI(Container, "groupContainer1") as Container;
			groupContainer2 = getUI(Container, "groupContainer2") as Container;
			heroListScroll = getUI(ScrollBar, "scrollList") as ScrollBar;
			
			sortChildIndex();
			
			heroList.layout = new HorizontalTileLayout(heroList);
			heroList.layout.hGap = -37;
			heroList.layout.vGap = -37;
			heroListScroll.orientation = ScrollBarOrientation.VERTICAL;
			heroListScroll.view = heroList;
			
			groupContainer1.layout = new FlowLayout(groupContainer1);
			groupContainer2.layout = new FlowLayout(groupContainer2);
			
			group1 = new Vector.<Player>();
			group2 = new Vector.<Player>();
			playerList = new Vector.<Player>();
			componentList = new Vector.<BattleRoomPlayerComponent>();
			_heroComponentList = new Vector.<BattleRoomHeroComponent>();
			_heroComponentIndex = new Dictionary();
			
			btnCardConfig.addEventListener(MouseEvent.CLICK, onBtnCardConfigClick);
			_btnReady.addEventListener(MouseEvent.CLICK, onBtnReadyClick);
		}
		
		private function onBtnCardConfigClick(evt: MouseEvent): void
		{
			dispatchEvent(new BattleRoomEvent(BattleRoomEvent.CARD_CONFIG_CLICK));
		}
		
		private function onBtnReadyClick(evt: MouseEvent): void
		{
//			if(isOwner)
//			{
//				_ready = true;
//			}
//			else
//			{
//				_ready = !_ready;
//				
//				if(_ready)
//				{
//					_btnReady.caption = "取消准备";
//				}
//				else
//				{
//					_btnReady.caption = "准备完毕";
//				}
//			}
			
			var event: BattleRoomEvent = new BattleRoomEvent(BattleRoomEvent.READY_CLICK);
			event.value = !_ready;
			dispatchEvent(event);
		}
		
		public function switchReady(value: Boolean): void
		{
			_ready = value;
			
			if(_ready)
			{
				_btnReady.caption = "取消准备";
			}
			else
			{
				_btnReady.caption = "准备完毕";
			}
		}
		
		public function show(callback: Function = null): void
		{
			y = -600;
			
			TweenLite.to(this, .5, {y: 0, ease: Strong.easeOut, onComplete: callback});
		}
		
		public function hide(callback: Function = null): void
		{
			TweenLite.to(this, .5, {y: -600, ease: Strong.easeIn, onComplete: callback});
		}
		
		public function addHero(value: BattleRoomHeroComponent): void
		{
			if(value != null)
			{
				_heroComponentIndex[value.heroCardParameter.id] = value;
				_heroComponentList.push(value);
				heroList.add(value);
				heroList.layout.update();
				heroListScroll.rebuild();
			}
		}
		
		public function addPlayer(p: Player): void
		{
			if(p != null)
			{
				var component: BattleRoomPlayerComponent = new BattleRoomPlayerComponent();
				component.player = p;
				componentList.push(component);
				playerList.push(p);
				
				if(p.group == 1)
				{
					group1.push(p);
					groupContainer1.add(component);
					groupContainer1.layout.update();
				}
				else if(p.group == 2)
				{
					group2.push(p);
					groupContainer2.add(component);
					groupContainer2.layout.update();
				}
			}
		}
		
		public function removePlayer(guid: String): void
		{
			var i: int;
			var component: BattleRoomPlayerComponent;
			var p: Player;
			for(i = 0; i<componentList.length; i++)
			{
				component = componentList[i];
				if(component.player.guid == guid)
				{
					p = component.player;
					break;
				}
			}
			if(component != null)
			{
				componentList.splice(i, 1);
			}
			if(p != null)
			{
				i = playerList.indexOf(p);
				if(i >= 0)
				{
					playerList.splice(i, 1);
				}
				if(p.group == 1)
				{
					i = group1.indexOf(p);
					if(i >= 0)
					{
						group1.splice(i, 1);
					}
					groupContainer1.remove(component);
				}
				else
				{
					i = group2.indexOf(p);
					if(i >= 0)
					{
						group2.splice(i, 1);
					}
					groupContainer2.remove(component);
				}
			}
		}
		
		public function setPlayerReady(guid: String, ready: Boolean): void
		{
			var component: BattleRoomPlayerComponent;
			for(var i: int = 0; i<componentList.length; i++)
			{
				component = componentList[i];
				if(component.player.guid == guid)
				{
					component.ready = ready;
					component.player.ready = ready;
					break;
				}
			}
		}
		
		public function setPlayerHero(guid: String, cardId: String): void
		{
			var component: BattleRoomPlayerComponent;
			for(var i: int = 0; i<componentList.length; i++)
			{
				component = componentList[i];
				if(component.player.guid == guid)
				{
					if(component.player.group == currentGroup)
					{
						component.avatarImage = cardId;
					}
				}
			}
		}

		public function get btnReady():CaptionButton
		{
			return _btnReady;
		}

		public function get heroComponentList():Vector.<BattleRoomHeroComponent>
		{
			return _heroComponentList;
		}

		public function get ready():Boolean
		{
			return _ready;
		}

		public function get heroComponentIndex():Dictionary
		{
			return _heroComponentIndex;
		}


	}
}