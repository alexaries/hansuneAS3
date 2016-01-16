package hansune.media
{
	/**
	 *  SuperSound 의 음악 파일 정보를 담는 아이템
	 * @author hansoo
	 * 
	 */
	public class SuperSoundItem {
		
		/**
		 * bgm 사운드의 루프여부 
		 */
		public var isLoop:Boolean = true;
		/**
		 *음악 파일의 경로 (mp3 파일 권장)
		 */
		public var sourceUrl:String = "";
		/**
		 * 음악 파일의 별칭
		 */
		public var name:String = "";
		
		/**
		 *  SuperSound 생성자
		 * @param sourceUrl
		 * @param name
		 * @param isLoop
		 * 
		 */
		public function SuperSoundItem(sourceUrl:String, name:String, isLoop:Boolean = false){
			this.isLoop = isLoop;
			this.sourceUrl = sourceUrl;
			this.name = name;
		}
	}
}