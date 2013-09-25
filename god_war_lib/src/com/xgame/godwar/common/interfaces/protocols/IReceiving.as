package com.xgame.godwar.common.interfaces.protocols
{
	import flash.utils.ByteArray;

	public interface IReceiving
	{
		function fill(data: ByteArray): void;
		function fillTimestamp(data: ByteArray): void;
		function equals(value: IReceiving): Boolean;
	}
}