package com.xgame.godwar.core.room.views
{
	import com.xgame.godwar.common.pool.ResourcePool;
	import com.xgame.godwar.liteui.core.Component;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	public class GamePaiDuiComponent extends Component
	{
		private var resourceList: Vector.<BitmapData>;
		private var bitmap: Bitmap;
		private var originHeight: int;
		
		public function GamePaiDuiComponent()
		{
			super(null);
			
			resourceList = new Vector.<BitmapData>();
			
			var bd: BitmapData = ResourcePool.instance.getBitmapData("assets.resource.card.Paidui100");
			originHeight = bd.height;
			resourceList.push(bd);
			bd = ResourcePool.instance.getBitmapData("assets.resource.card.Paidui80");
			resourceList.push(bd);
			bd = ResourcePool.instance.getBitmapData("assets.resource.card.Paidui60");
			resourceList.push(bd);
			bd = ResourcePool.instance.getBitmapData("assets.resource.card.Paidui40");
			resourceList.push(bd);
			bd = ResourcePool.instance.getBitmapData("assets.resource.card.Paidui20");
			resourceList.push(bd);
			
			bitmap = new Bitmap(resourceList[0]);
			addChild(bitmap);
		}
		
		public function set percent(value: int): void
		{
			value = Math.max(0, value);
			value = Math.min(100, value);
			
			if(value > 80 && value <= 100)
			{
				value = 0;
			}
			else if(value > 60)
			{
				value = 1;
			}
			else if(value > 40)
			{
				value = 2;
			}
			else if(value > 20)
			{
				value = 3;
			}
			else
			{
				value = 4;
			}
			
			bitmap.bitmapData = resourceList[value];
			bitmap.y = originHeight - bitmap.bitmapData.height;
		}
	}
}