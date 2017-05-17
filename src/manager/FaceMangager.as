package manager 
{
import body.Body;
import face.Surface;
import laya.display.Graphics;
/**
 * ...面管理
 * @author Kanon
 */
public class FaceMangager 
{
	public static var faceAry:Array = [];
	
	/**
	 * 添加一个面到管理池中
	 * @param	face	面
	 */
	public static function add(face:Surface):void
	{
		faceAry.push(face);
	}
	
	public static function clear():void
	{
		faceAry = [];
	}
	
	/**
	 * 禁锢一个物体在face上
	 * @param	face		面
	 * @param	body		物体
	 */
	public static function cageInFace(face:Surface, body:Body):void
	{
		if (!face || !body) return;
		if (face.upBlock && body.y < face.upPosY)
			body.y = face.upPosY;
			
		if (face.downBlock && body.y > face.downPosY)
			body.y = face.downPosY;
		
		if (face.leftBlock || face.leftH > 0)
		{
			var leftX:Number = face.getLeftRange(body.y) + body.thick;
			if (body.x < leftX) body.x = leftX;
		}
		
		if (face.rightBlock || face.rightH > 0)
		{
			var rightX:Number = face.getRightRange(body.y) - body.thick;
			if (body.x > rightX) body.x = rightX;
		}
	}
	
	/**
	 * 搜索面
	 * @param	x		body的x坐标
	 * @param	y		body的y坐标
	 * @param	thick	body的厚度
	 * @return	搜索到的面
	 */
	public static function seachFace(x:Number, 
									 y:Number, 
									 thick:Number = 0):Surface
	{
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			if (face.inFaceRage(x, y, thick))
			{
				return face;
			}
		}
		return null;
	}
	
	/**
	 * 搜索向上跳跃时body在face的范围内
	 * @param	x			body的x坐标	
	 * @param	z			body的z坐标
	 * @param	thick		body的厚度
	 * @return	搜索到面的数组
	 */
	public static function seachTopJumpFaceRange(x:Number, z:Number, thick:Number = 0):Array
	{
		var arr:Array = [];
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			if (z + 1 == face.z && face.inDownRange(x, thick))
				arr.push(face);
			if (z == face.z && face.inUpRange(x, thick))
				arr.push(face);
		}
		arr.sort(function(a:Surface, b:Surface):Number { return a.z > b.z ? 1 : -1});
		return arr;
	}
	
	/**
	 * debug 所有的face
	 * @param	g			绘图容器
	 * @param	lineColor	线条颜色
	 * @param	pointColor	锚点颜色
	 */
	public static function debugFace(g:Graphics, lineColor:String = "#FF0000", 
												pointColor:String = "#FFFF00", 
												heighColor:String = "#0000FF"):void
	{
		if (!g) return;
		g.clear();
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			face.debugDraw(g, lineColor, pointColor, heighColor);
		}
	}
}
}