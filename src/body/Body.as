package body 
{
import face.Surface;
import laya.display.Node;
import manager.FaceMangager;
import manager.FaceMangager;
/**
 * ...物体
 * @author Kanon
 */
public class Body 
{
	private static const NONE:int = 0;
	private static const LEFT:int = 1;
	private static const RIGHT:int = 2;
	//速度
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var jumpVy:Number = 0;
	//当前帧的坐标
	public var x:Number = 0;
	public var y:Number = 0;
	//上一帧的坐标
	public var prevX:Number = 0;
	public var prevY:Number = 0;
	//重力
	public var g:Number = 2;
	//当前所在的地面
	public var face:Surface;
	//显示对象
	public var display:Node;
	//厚度
	public var thick:Number = 0;
	//方向
	public var direction:int;
	public function Body() 
	{
		
	}
	
	/**
	 * 更新方向
	 */
	protected function updateDirection():void
	{
		if (this.vx > 0)
			this.direction = RIGHT;
		else if (this.vx < 0)
			this.direction = LEFT;
		else
			this.direction = NONE;
	}
	
	/**
	 * 更新位置
	 */
	protected function updatePosition():void
	{
		this.prevX = this.x;
		this.prevY = this.y;
		this.x += this.vx;
		this.y += this.jumpVy;
		if (this.face)
		{
			this.y += this.vy;
			this.jumpVy = 0;
			FaceMangager.cageInFace(this.face, this);
		}
		else 
		{
			this.jumpVy += this.g;
		}
	}
	
	/**
	 * 更新面
	 */
	protected function updateFace():void
	{
		var thich:Number = this.thick;
		if (this.face && !this.face.inFaceRage(this.x, this.y, this.thick))
		{
			trace("out");
			this.face = null;
		}
		if (!this.face)
		{
			//TODO 判断跳跃后y坐标应该到达的位置 才开始搜索
			this.face = FaceMangager.seachFace(this.x, this.y, 
											   this.prevX, this.prevY, 
											   this.thick);
		}
	}
	
	/**
	 * 更新显示
	 */
	protected function updateDisplay():void
	{
		if (this.display)
		{
			this.display.x = this.x;
			this.display.y = this.y;
		}
	}
	
	/**
	 * 跳跃
	 * @param	speed
	 */
	public function jump(speed:Number):void
	{
		if (!this.face) return;
		this.jumpVy = speed;
		this.face = null;
	}
	
	/**
	 * 更新
	 */
	public function update():void
	{
		this.updateDirection();
		this.updatePosition();
		this.updateFace();
		this.updateDisplay();
	}
}
}