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
		
		if (face.leftBlock)
		{
			var leftX:Number = face.getLeftRange(body.y) + body.thick;
			if (body.x < leftX) body.x = leftX;
		}
		
		if (face.rightBlock)
		{
			var rightX:Number = face.getRightRange(body.y) - body.thick;
			if (body.x > rightX) body.x = rightX;
		}
	}
	
	/**
	 * 搜索面
	 * @param	x		当前坐标x
	 * @param	y		当前坐标y
	 * @param	thick	厚度
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
	 * 根据深度搜索face
	 * @param	x		当前坐标x	
	 * @param	y		当前坐标y
	 * @param	z		当前face的z坐标
	 * @param	thick	厚度
	 * @param	state	搜索状态	0：只搜深度>=当前face的深度，1：同深度跳跃，2只搜索<=当前face深度
	 */
	public static function seachFaceByDepth(x:Number, y:Number, z:Number, 
											thick:Number = 0, state:int = 0)
	{
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			if (state == 0)
			{
				//往上跳跃时
				if (face.z < z) continue
			}
			else if (state == 1)
			{
				//同级别跳跃时
				if (face.z != z) continue
			}
			else if (state == 2)
			{
				//往下跳跃时
				if (face.z > z) continue
			}
			if (face.inFaceRage(x, y, thick))
			{
				return face;
			}
		}
		return null;
	}

	
	/**
	 * debug 所有的face
	 * @param	g			绘图容器
	 * @param	lineColor	线条颜色
	 * @param	pointColor	锚点颜色
	 */
	public static function debugFace(g:Graphics, lineColor:String = "#ff0000", pointColor:String="#ff0000"):void
	{
		if (!g) return;
		g.clear();
		var count:int = faceAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = faceAry[i];
			face.debugDraw(g, lineColor, pointColor);
		}
	}
}
}