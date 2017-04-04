package 
{
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
	//左边斜率
	private var _leftSkew:Number = 0;
	//右边斜率
	public var rightkew:Number = 0;
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
		if (this.leftSkew == 90) return this.upLeftPoint.x;
		var rand:Number = this.leftSkew * Math.PI / 180;
		trace(" this.leftSkew", this.leftSkew);
		var vx:Number = this.height / Math.tan(rand);
		trace(vx);
		var sh:Number = this.y + this.height - (posY - this.y);
		var dx:Number = sh / Math.tan(rand);
		return this.x + dx;
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
}
}