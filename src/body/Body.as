package body 
{
import face.Surface;
import laya.display.Node;
import manager.FaceMangager;
/**
 * ...物体
 * TODO 
 * [绘制出face的高度]
 * [区分跳跃和链接]
 * [区分下落和链接]
 * [区分跳跃时下落和移动时下落]
 * [跳跃时限制左右移动]
 * [跳跃时不判断face的cage]
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
	private var positionState:int;
	//下落之前的y坐标
	private var prevFaceY:Number;
	//---public---
	//速度
	public var vx:Number = 0;
	public var prevVx:Number = 0;
	public var vy:Number = 0;
	public var jumpVx:Number = 0;
	public var jumpVy:Number = 0;
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
		this.x += this.jumpVx;
		this.y += this.jumpVy;
		if (this.face)
		{
			this.y += this.vy;
			this.jumpVy = 0;
		}
		else 
		{
			//fall
			this.jumpVy += this.g;
		}
	}
	
	/**
	 * 更新面
	 */
	protected function updateFace():void
	{
		if (this.face)
		{
			//禁锢
			FaceMangager.cageInFace(this.face, this);
			//face边界限制上下
			FaceMangager.restrictInFace(this.face, this);
			if (!this.face.inFaceRage(this.x, this.y, this.thick))
			{
				this.prevFaceY = this.y;
				this.prevFace = this.face;
				this.face = FaceMangager.seachLinkFace(this.x, this.y, this.thick);
			}
		}
		else
		{
			if (!this.isJump)
			{
				if (!this.prevFace || this.jumpVy == 0)
				{
					//非跳跃时的face链接
					this.face = FaceMangager.seachLinkFace(this.x, this.y, this.thick);
				}
				else
				{
					//非跳跃时的下落face搜索
					var count:int = FaceMangager.faceAry.length;
					for (var i:int = 0; i < count; ++i)
					{
						var face:Surface = FaceMangager.faceAry[i];
						var posY:Number = this.prevFaceY;
						if (this.prevFace != face)
						{
							if (this.prevFace.z == face.z)
							{
								//同一深度的face
								var height:Number = face.downPosY - this.prevFace.downPosY;
								posY = this.prevFaceY + height;
							}
							else if (this.prevFace.z - 1 == face.z)
							{
								//下边界下落
								if (face.inUpRange(this.x, this.thick))
									posY = face.upPosY;
							}
						}
						if (this.y >= posY && this.prevY < posY)
						{
							this.face = face;
							this.y = posY;
							this.jumpVx = 0;
							this.jumpVy = 0;
							this.vx = 0;
							this.vy = 0;
							return;
						}
					}
				}
			}
			else
			{
				if (this.jumpVy >= 0)
				{
					trace("positionState", this.positionState);
					if (this.positionState == UP)
					{
						var faceAry:Array = FaceMangager.seachTopJumpFaceRange(this.x, this.prevZ, this.thick);
						var count:int = faceAry.length; 
						for (var i:int = 0; i < count; i++) 
						{
							var face:Surface = faceAry[i];
							var posY:Number = Infinity;
							if (face.z - 1 == this.prevZ)
							{
								posY = face.downPosY;
							}
							if (face.z == this.prevZ)
							{
								posY = face.upPosY;
							}
							if (this.y >= posY && this.prevY < posY)
							{
								this.isJump = false;
								this.face = face;
								this.y = posY;
								this.jumpVx = 0;
								this.jumpVy = 0;
								this.vx = 0;
								this.vy = 0;
								this.positionState = NONE;
								return;
							}
						}
					}
					else if (this.positionState == NONE || 
							 this.positionState == DOWN)
					{
						if (this.jumpVx == 0)
						{
							//原地跳跃
							if (this.y >= this.prevFaceY && this.prevY < this.prevFaceY)
							{
								this.isJump = false;
								this.face = this.prevFace;
								this.y = this.prevFaceY;
								this.jumpVy = 0;
								this.positionState = NONE;
								return;
							}
						}
						else
						{
							var count:int = FaceMangager.faceAry.length;
							for (var i:int = 0; i < count; ++i)
							{
								var face:Surface = FaceMangager.faceAry[i];
								var posY:Number = this.prevFaceY;
								if (this.prevFace != face)
								{
									if (this.prevFace.z == face.z)
									{
										//同一深度的face
										var height:Number = face.downPosY - this.prevFace.downPosY;
										posY = this.prevFaceY + height;
									}
									else if (this.prevFace.z - 1 == face.z)
									{
										//下边界下落
										if (face.inUpRange(this.x, this.thick))
											posY = face.upPosY;
									}
								}
								if (this.y >= posY && this.prevY < posY)
								{
									this.face = face;
									this.isJump = false;
									this.y = posY;
									this.jumpVx = 0;
									this.jumpVy = 0;
									this.vx = 0;
									this.vy = 0;
									return;
								}
							}
						}
					}
				}
			}
		}
	}
	
	/**
	 * 更新跳跃的横向速度
	 */
	protected function updateJumpVx():void
	{
		if (this.isJump)
		{
			if (this.vx != 0)
			{
				this.jumpVx = this.vx;
				this.prevVx = this.vx;
				this.vx = 0;
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
	 * 更新body在face的位置状态
	 * @param	face		当前所在的face
	 */
	protected function updateFacePosState(face:Surface):void
	{
		if (!face) return;
		//在 顶部 跳跃
		if (this.y <= face.upPosY)
			this.positionState = UP;
		else if (this.y >=face.downPosY)
			this.positionState = DOWN;
		else 
			this.positionState = NONE;

	}
	
	/**
	 * 跳跃
	 * @param	speed
	 */
	public function jump(speed:Number):void
	{
		if (this.isJump || !this.face) return;
		this.prevFaceY = this.y;
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
		if (this.isJump || !this.face) return;
		this.vx = vx;
	}
	
	/**
	 * 纵向移动
	 * @param	vy
	 */
	public function moveV(vy:Number):void
	{
		if (this.isJump || !this.face) return;
		this.vy = vy;
	}
	
	/**
	 * 更新
	 */
	public function update():void
	{
		this.updateDirection();
		this.updatePosition();
		this.updateJumpVx();
		this.updateFacePosState(this.face);
		this.updateFace();
		this.updateDisplay();
	}
}
}