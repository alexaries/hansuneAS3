package hansune.net
{
	import flash.utils.ByteArray;

    public class NConnectorData
    {
        public static const HEAD:String = "]=[";
        public static const RAW:String = "r+w";
        public static const STR:String = "s+r";
        
        public var type:String = "";
        public var data:*;
        public var tokenID:int = 10;
        
        public function NConnectorData(type:String, data:*, tokenID:int = 10) {
            this.type = type;
            this.tokenID = tokenID;
            this.data = data;
        }
		
		/**
		 * 문자형 NConnectorData 생성
		 * @param str
		 * @param tokenID
		 * @return 
		 * 
		 */
		public static function makeStringData(str:String, tokenID:int = 10):ByteArray {
			var raw:ByteArray = new ByteArray();
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(str);
			bytes.position = 0;
			raw.writeUTFBytes(NConnectorData.HEAD);
			raw.writeInt(3 + 4 + bytes.length);
			raw.writeUTFBytes(NConnectorData.STR);//헤드설정
			raw.writeInt(tokenID);
			raw.writeBytes(bytes);
			
			return raw;
		}
		
		/**
		 * 바이트형 NConnectorData 생성
		 * @param data
		 * @param tokenID
		 * @return 
		 * 
		 */
		public static function makeBytesData(data:ByteArray, tokenID:int = 10):ByteArray {
			var raw:ByteArray = new ByteArray();
			raw.writeUTFBytes(NConnectorData.HEAD);
			raw.writeInt(3 + 4 + data.length);
			raw.writeUTFBytes(NConnectorData.RAW);//바이트어레이로 보낸다는 헤드설정
			raw.writeInt(tokenID);
			raw.writeBytes(data);
			
			return raw;
		}
    }
}