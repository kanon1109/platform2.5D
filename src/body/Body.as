package body 
{
import face.Surface;
import laya.display.Node;
import manager.FaceMangager;
/**
 * ...物体
 * TODO 
 * 跳跃时限制左右移动
 * 跳跃时不判断face的cage
 * 跳跃后触底在判断face
 * 跳跃判断高度
 * 跨高度搜索face
 * 碰壁后反弹
 * @author Kanon
 */
public class Body 
{
	//方向常量
	private static const NONE:int = 0;
	private static const LEFT:int = 1;
	private static const RIGHT:int = 2;
	private static const UP:int = 3;
	private static const DOWN:int = 4;
	//是否跳跃状态
	private var isJump:Boolean;
	//跳跃时的方向
	private var jumpDirect:int;
	//---public---
	//速度
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var jumpVy:Number = 0;
	//跳跃前的y坐标
	public var jumpY:Number = 0;
	//当前帧的坐标
	public var x:Number = 0;
	public var y:Number = 0;
	//上一帧的坐标
	public var prevX:Number = 0;
	public var prevY:Number = 0;
	public var prevZ:Number = 0;
	//重力
	public var g:Number = .98;
	//当前所在的地面
	public var face:Surface;
	public var prevFace:Surface;
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
			this.face = null;
		if (!this.isJump)
		{
			if (!this.face)
			{
				//TODO 判断跳跃后y坐标应该到达的位置 才开始搜索
				this.face = FaceMangager.seachFace(this.x, this.y, this.thick);
			}
		}
		else
		{
			if (this.jumpVy >= 0)
			{
				/*var face:Surface = FaceMangager.seachFaceRangeByDepth(this.x, this.y, this.prevZ, this.thick, 0);
				if (face)
				{
					//TODO 判断是否从当前face的顶部跳跃
					if (this.jumpDirect == UP)
					{
						//TODO
						//根据深度搜索
						//根据face的深度判断着陆点
						//可能碰到的face
						var posY:Number = Infinity;
						if (face.z + 1 == this.prevZ)
						{
							//找到上一层的面
							posY = face.downPosY;
							trace("in1", this.y, face.downPosY);
						}
						if (this.y >= posY)
						{
							this.y = posY;
							this.face = face;
							this.isJump = false;
							this.jumpVy = 0;
							return;
						}
					}
					else if (this.jumpDirect == DOWN)
					{
						
					}
				}*/
			}
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
		if (this.isJump || !this.face) return;
		//在 顶部 跳跃
		if (this.y == this.face.upPosY)
			this.jumpDirect = UP;
		else if (this.y == this.face.downPosY)
			this.jumpDirect = DOWN;
		this.jumpY = this.y;
		this.jumpVy = -speed;
		this.isJump = true;
		this.prevZ = this.face.z;
		this.prevFace = this.face;
		this.face = null;
	}
	
	/**
	 * 横向移动
	 * @param	vx
	 */
	public function moveH(vx:Number):void
	{
		if (this.isJump) return;
		this.vx = vx;
	}
	
	/**
	 * 纵向移动
	 * @param	vy
	 */
	public function moveV(vy:Number):void
	{
		if (this.isJump) return;
		this.vy = vy;
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