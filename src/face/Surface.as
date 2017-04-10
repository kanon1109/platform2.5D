package face 
{
import laya.display.Graphics;
import laya.maths.Point;
import laya.maths.MathUtil;
/**
 * ...地面
 * 包含地面的属性
 * @author Kanon
 */
public class Surface 
{
	//x坐标
	public var x:Number = 0;
	//y坐标
	public var y:Number = 0;
	//z坐标
	public var z:Number = 0;
	//左边是否阻碍
	public var leftBlock:Boolean;
	//右边是否是阻碍
	public var rightBlock:Boolean;
	//上边是否阻碍
	public var upBlock:Boolean;
	//下边是否是阻碍
	public var downBlock:Boolean;
	//左上点坐标
	public var upLeftPoint:Point;
	//右上点坐标
	public var upRightPoint:Point;
	//左下点坐标
	public var downleftPoint:Point;
	//右下点坐标
	public var downRightPoint:Point;
	//左边高
	protected var _leftH:Number = 0;
	//右边高
	protected var _rightH:Number = 0;
	//上边高
	protected var _upH:Number = 0;
	//下边高（一般为0）
	protected var _downH:Number = 0;
	public function Surface(upLeft:Number = 0, downLeft:Number = 0, 
							upRight:Number = 100, downRight:Number = 100, 
							up:Number = 0, down:Number = 100) 
	{
		this.upLeftPoint = new Point(upLeft, up);
		this.upRightPoint = new Point(upRight, up);
		this.downleftPoint = new Point(downLeft, down);
		this.downRightPoint = new Point(downRight, down);
		
		if (!this.validate())
			throw Error("surface is not parallelogram");
	}
	
	/**
	 * 左边高
	 */
	public function get leftH():Number{ return _leftH; }
	public function set leftH(value:Number):void 
	{
		_leftH = value;
		this.leftBlock = false;
	}
	
	/**
	 * 右边高
	 */
	public function get rightH():Number{ return _rightH; }
	public function set rightH(value:Number):void 
	{
		_rightH = value;
		this.rightBlock = false;
	}
	
	/**
	 * 上边高
	 */
	public function get upH():Number{ return _upH; }
	public function set upH(value:Number):void 
	{
		_upH = value;
		this.upBlock = false;
	}
	
	/**
	 * 下边高（一般为0）
	 */
	public function get downH():Number{ return _downH; }
	public function set downH(value:Number):void 
	{
		_downH = value;
		this.downBlock = false;
	}
	
	/**
	 * 获取左边边界坐标
	 * @param	posY	当前在这个face上的y坐标
	 * @return	左边边界的坐标
	 */
	public function getLeftRange(posY:Number):Number
	{
		if (Math.abs(this.leftSkew) == 90) return this.x + this.upLeftPoint.x;
		var skew:Number = this.leftSkew;
		if (skew > 90) skew = 180 - this.leftSkew;
		var rand:Number = skew * Math.PI / 180;
		var sh:Number = this.y + this.upLeftPoint.y + this.height - posY;
		var dx:Number;
		if (this.leftSkew < 90) dx = this.height / Math.tan(rand) - sh / Math.tan(rand);
		else dx = sh / Math.tan(rand);
		var leftX:Number = this.upLeftPoint.x;
		if (this.leftSkew > 90) leftX = this.downleftPoint.x;
		return this.x + leftX + dx;
	}
	
	/**
	 * 获取右边边界的坐标
	 * @param	posY	当前在这个face上的y坐标
	 * @return	右边边界的坐标
	 */
	public function getRightRange(posY:Number):Number
	{
		if (Math.abs(this.rightSkew) == 90) return this.x + this.upRightPoint.x;
		var skew:Number = this.rightSkew;
		if (skew > 90) skew = 180 - this.rightSkew;
		var rand:Number = skew * Math.PI / 180;
		var sh:Number = this.y + this.upLeftPoint.y + this.height - posY;
		var dx:Number;
		if (this.rightSkew < 90) dx = this.height / Math.tan(rand) - sh / Math.tan(rand);
		else dx = sh / Math.tan(rand);
		var rightX:Number = this.upRightPoint.x;
		if (this.rightSkew > 90) rightX = this.downRightPoint.x;
		return this.x + rightX + dx;
	}
	
	/**
	 * 高度
	 */
	public function get height():Number
	{
		return this.downleftPoint.y - this.upLeftPoint.y;
	}
		
	/**
	 * 计算左边的倾斜角度
	 * @return
	 */
	public function get leftSkew():Number
	{
		return MathUtil.getRotation(this.upLeftPoint.x, 
									this.upLeftPoint.y, 
									this.downleftPoint.x, 
									this.downleftPoint.y);
	}
	
	/**
	 * 计算右边的倾斜角度
	 * @return
	 */
	public function get rightSkew():Number
	{
		return MathUtil.getRotation(this.upRightPoint.x, 
									this.upRightPoint.y, 
									this.downRightPoint.x, 
									this.downRightPoint.y);
	}
	
	/**
	 * 是否在横向范围内
	 * @param	posY	当前的y坐标
	 * @return
	 */
	public function inHorizontalRange(posY:Number):Boolean
	{
		return posY >= this.y + this.upLeftPoint.y && 
				posY <= this.y + this.downleftPoint.y
	}

	/**
	 * 是否在上边范围内
	 * @param	posX	当前x坐标
	 */
	public function inUpRange(posX:Number):void
	{
		return posX >= this.x + this.upLeftPoint.x && 
				posX <= this.x + this.upRightPoint.x;
	}
	
	/**
	 * 是否在下边范围内
	 * @param	posX	当前x坐标
	 */
	public function inDownRange(posX:Number):void
	{
		return posX >= this.x + this.downleftPoint.x && 
				posX <= this.x + this.downRightPoint.x;
	}
	
	/**
	 * 验证面的合法性
	 * @return
	 */
	public function validate():Boolean
	{
		return this.upLeftPoint.y == this.upRightPoint.y && 
			   this.downleftPoint.y == this.downRightPoint.y;
	}
	
	/**
	 * 绘制
	 * @param	g	画布
	 * @param	lineColor	线条颜色
	 * @param	pointColor	锚点颜色
	 */
	public function debugDraw(g:Graphics, lineColor:String = "#ff0000", pointColor:String="#ff0000"):void
	{
		if (!g) return;
		g.drawLine(this.x + this.upLeftPoint.x, 
					this.y + this.upLeftPoint.y,
					this.x + this.upRightPoint.x,
					this.y + this.upRightPoint.y, 
					lineColor);
					
		g.drawLine(this.x + this.upLeftPoint.x, 
					this.y + this.upLeftPoint.y,
					this.x + this.downleftPoint.x,
					this.y + this.downleftPoint.y, 
					lineColor);
					
		g.drawLine(this.x + this.downleftPoint.x, 
					this.y + this.downleftPoint.y,
					this.x + this.downRightPoint.x,
					this.y + this.downRightPoint.y, 
					lineColor);
		
		g.drawLine(this.x + this.upRightPoint.x, 
					this.y + this.upRightPoint.y,
					this.x + this.downRightPoint.x,
					this.y + this.downRightPoint.y, 
					lineColor);
					
		g.drawCircle(this.x, this.y, 3, pointColor);
	}
}
}