//------------------------------------------------------------------------------
// 
//   https://github.com/brownsoo/AS3-Hansune 
//   Apache License 2.0  
//
//------------------------------------------------------------------------------

package hansune.gl
{
	import flash.geom.Vector3D;
	
	/**
	 * HGraphics class
	 * this class provide some methods for graphics algorithm.
	 * 
	 * @author 	hansoo
	 * @version 0.1
	 * @date	2010-02-04
	 */
	 
	public class HGraphics
	{
		private static var calcxyz:Vector3D = new Vector3D(0,0,0,0);
		private static var increment:Number;
		private static var interval:Number;
		private static var j:int;
		private static var output_index:int;
		
		private static var units:Array = new Array();
		
		private static var value:Number;

		/**
		 * 
		 * @param n the number of control points minus 1
		 * @param t the degree of the polynomial plus 1
		 * @param control control point array made up of Vector3D  
		 * @param output array in which the calculate spline points are to be put
		 * @param num_output how many points on the spline are to be calculated
		 * 
		 * Pre-conditions:
		 * n+2>t  (no curve results if n+2<=t)
		 * control array contains the number of points specified by n
		 * output array is the proper size to hold num_output Vector3Ds
		 */
		 
		static public  function bSpline(n:int, t:int, control:Vector3DArray, output:Vector3DArray, num_output:int):void
		{
			//var u:Array;
			//var increment:Number;
			//var interval:Number;
			//var output_index:int;
			//var calcxyz:Vector3D = new Vector3D(0,0,0,0);
			calcxyz.x = 0;
			calcxyz.y = 0;
			calcxyz.z = 0;
			calcxyz.w = 0;
			
			
			//u = new Array(n + t + 1);
			units = [];
			//compute_intervals(units, n, t);		
	 		for (j=0; j<=n+t; j++){
	 			if (j<t){
	 				units[j]=0; 
	 			} else if ((t<=j) && (j<=n)) { 
	 				units[j]=j-t+1; 
	 			} else if (j>n){
	 				units[j]=n-t+2;
	 			}  // if n-t=-2 then we're screwed, everything goes to 0
	  		}
			
			increment = (n-t+2)/(num_output - 1); // how much parameter goes up each time
			interval = 0;
			
			for(output_index=0; output_index < num_output-1; output_index++)
			{
				compute_point(units, n, t, interval, control, calcxyz);
				output[output_index].x = calcxyz.x;
				output[output_index].y = calcxyz.y;
				output[output_index].z = calcxyz.z;
				interval = interval +  increment; // increment our parameter
			}
			
			output[num_output - 1].x = control[n].x;
			output[num_output - 1].y = control[n].y;
			output[num_output - 1].z = control[n].z;
			
			units = [];
		}
		static private  function blend(k:int, t:int, u:Array, v:Number):Number  // calculate the blending value
		{
	 		//var value:Number;
	
			  if (t==1)			// base case for the recursion
			  {
			    if ((u[k]<=v) && (v<u[k+1]))
			      value=1;
			    else
			      value=0;
			  }
			  else
			  {
			    if ((u[k+t-1]==u[k]) && (u[k+t]==u[k+1]))  // check for divide by zero
			      value = 0;
			    else
			    if (u[k+t-1]==u[k]) // if a term's denominator is zero,use just the other
			      value = (u[k+t] - v) / (u[k+t] - u[k+1]) * blend(k+1, t-1, u, v);
			    else
			    if (u[k+t]==u[k+1])
			      value = (v - u[k]) / (u[k+t-1] - u[k]) * blend(k, t-1, u, v);
			    else
			      value = (v - u[k]) / (u[k+t-1] - u[k]) * blend(k, t-1, u, v) +
				      (u[k+t] - v) / (u[k+t] - u[k+1]) * blend(k+1, t-1, u, v);
			  }
	 		 return value;
		}
		
		
		/*
		// figure out the knots
		private static function compute_intervals(u:Array, n:int, t:int):void  {
	 		var j:int;
	 		
	 		for (j=0; j<=n+t; j++){
	 			if (j<t){ u[j]=0; }
	 			else if ((t<=j) && (j<=n)) { u[j]=j-t+1; }
	 			else if (j>n){u[j]=n-t+2;}  // if n-t=-2 then we're screwed, everything goes to 0
	  		}
		}
		*/
		
		static private function compute_point(u:Array, n:int, t:int, v:Number, control:Vector3DArray, output:Vector3D):void {
	  		var k:int;
	  		var temp:Number;
	  		
	  		// initialize the variables that will hold our outputted point
	  		output.x=0;
	  		output.y=0;
	  		output.z=0;
	
			for (k=0; k<=n; k++)
			{
				temp = blend(k,t,u,v);  // same blend is used for each dimension coordinate
				output.x = output.x + control[k].x * temp;
				output.y = output.y + control[k].y * temp;
				output.z = output.z + control[k].z * temp;
			}
		}
	}
}