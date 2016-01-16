//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

package hansune.gl
{
	import flash.geom.Vector3D;
	public dynamic class Vector3DArray extends Array
	{
		public function Vector3DArray(numElements:int=0)
		{
			//ary = new Array(numElements);
			super(numElements);
			
			if(numElements) {
				for(var i:int=0; i<numElements; i++){	
					this[i] = new Vector3D(0,0,0,0);
				}
			}
		}
		
		
		public function getItemAt(index:uint):Vector3D {
			return this[index];
		}
        
		public function setItemAt(index:uint, item:Vector3D):void {
            this[index] = item;
		}
        /*
		private var ary:Array;
		
		
		
		public function pop():Object {
			return ary.pop();
		}
		
		public function push(...args):uint{
			if((args as Array).every(chkNpoint)) {
				return ary.push(args);
			} else {
				throw Error("Elements only Vector3D");
			}
		}
		public function shift():Object {
			return ary.shift();
		}
        
        public function toString():String {
        	return ary.toString();
        }
		
		public function unshift(...args):uint{
			if((args as Array).every(chkNpoint)) {
				return ary.unshift(args);
			} else {
				throw Error("Elements only Vector3D");
			}
		}
		
		private function chkNpoint(element:*, index:int, arr:Array):Boolean {
            return (element is Vector3D);
        }
        */
	}
}