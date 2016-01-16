package hansune.net
{
    import flash.net.Socket;
    import flash.utils.ByteArray;

	public interface IConnectorParser
	{
		function stringDataFromConnector(msg:String, from:Socket = null):void;
        function rawDataFromConnector(bytes:ByteArray, from:Socket = null, tokenID:int = 10):void;
	}
}