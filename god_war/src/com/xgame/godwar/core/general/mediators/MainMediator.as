package com.xgame.godwar.core.general.mediators
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainMediator extends Mediator implements IMediator
	{
		public static const NAME: String = "MainMediator";
		
		public function MainMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get component(): main
		{
			return viewComponent as main;
		}
		
		public function get stage(): Stage
		{
			return component.stage;
		}
		
		public function addChild(value: DisplayObject): void
		{
			component.addChild(value);
		}
		
		public function removeChild(value: DisplayObject): void
		{
			component.removeChild(value);
		}
		
		public function contains(value: DisplayObject): Boolean
		{
			return component.contains(value);
		}
	}
}