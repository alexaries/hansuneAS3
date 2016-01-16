//복사하는 함수
//만든사람 : 지돌스타
/////////////////////////////////////////////
//import com.hansune.utils.createClone;
/////////////////////////////////////////////
//var arr1:Array = new Array(2,3,4);
//var arr2:Array = createClone(arr1);
//trace(arr2);
/////////////////////////////////////////////


package hansune.utils
{
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.net.registerClassAlias;
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	
	public function createClone(source:*):*{
		var className:String = getQualifiedClassName(source);
		try {
			getClassByAlias(className);
		} catch(error:ReferenceError){
			registerClassAlias(className,getDefinitionByName(className) as Class);
		}
		
		var clone:ByteArray = new ByteArray();
		clone.writeObject(source);
		clone.position = 0;
		return clone.readObject();
	}
}