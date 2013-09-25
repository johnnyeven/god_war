package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.configuration.SocketContextConfig;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class Receive_Move_RequestFindPath extends ReceivingBase
	{
		public var path: Array;
		
		public function Receive_Move_RequestFindPath()
		{
			super(SocketContextConfig.REQUEST_FIND_PATH);
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				var x: int = int.MIN_VALUE;
				var y: int = int.MIN_VALUE;
				path = new Array();
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_INT:
							if(x == int.MIN_VALUE)
							{
								x = data.readInt();
								break;
							}
							if(y == int.MIN_VALUE)
							{
								y = data.readInt();
								break;
							}
					}
					
					if(x != int.MIN_VALUE && y != int.MIN_VALUE)
					{
						path.push(new Point(x, y));
						x = int.MIN_VALUE;
						y = int.MIN_VALUE;
					}
				}
			}
		}
	}
}