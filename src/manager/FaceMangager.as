package manager 
{
	import face.Surface;
/**
 * ...面管理
 * @author Kanon
 */
public class FaceMangager 
{
	private static var faceAry:Array = [];
	/**
	 * 添加一个面到管理池中
	 * @param	face	面
	 */
	public static function addFace(face:Surface):void
	{
		faceAry.push(face);
	}
	
	
	/**
	 * 搜索面
	 * @param	x		当前坐标x
	 * @param	y		当前坐标y
	 * @param	prevX	上一次坐标x
	 * @param	prevY	上一次坐标y
	 * @return	搜索到的面
	 */
	public static function seachFace(x:Number, 
									 y:Number, 
									 prevX:Number, 
									 prevY:Number):Surface
	{
		
	}
}
}