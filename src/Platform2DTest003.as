package 
{
import body.Body;
import face.Surface;
import laya.display.Sprite;
import laya.events.Event;
import laya.utils.Stat;
import manager.FaceMangager;
/**
 * ...面之间的跳跃
 * @author Kanon
 */
public class Platform2DTest003 
{
	private var spt:Sprite;
	private var ball:Sprite;
	private var faceArr:Array;
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var g:Number = .2;
	//刚体
	private var body:Body;
	public function Platform2DTest003() 
	{
		Laya.init(1136, 640);
		Stat.show(0, 0);
		this.spt = new Sprite();
		this.ball = new Sprite();
		this.ball.graphics.drawCircle(0, 0, 10, "#6633ff");

		Laya.stage.addChild(this.spt);
		Laya.stage.addChild(this.ball);
		
		this.body = new Body();
		this.body.x = 100;
		this.body.y = 200;
		this.body.thick = 10;
		this.body.display = ball;
		
		var startX:Number = 80;
		var gapH:Number = 21;
		for (var i:int = 0; i < 3; i++) 
		{
			var face:Surface = new Surface(50, 0, 150, 100);
			face.name = "face" + i;
			face.x = (100 + gapH) * i + startX ;
			face.y = 100;
			if (i == 0 || i == 1)
				face.upBlock = true;
				
			if (i == 0)
			{
				face.leftBlock = true;
			}
			
			if (i == 1)
			{
				face.rightBlock = true;
				face.downBlock = true;
			}
				
			if (i == 2) 
			{
				face.leftBlock = true;
				face.rightBlock = true;
				face.downBlock = true;
				face.x = startX - 50;
				face.y = 200;
			}
			if (i == 0) this.body.face = face;
			FaceMangager.add(face);
		}
		Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
		Laya.stage.on(Event.KEY_UP, this, onKeyUp);
		Laya.timer.frameLoop(1, this, loop);
	}
	
	private function onKeyUp(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		if (keyCode == 39 || keyCode == 37) this.body.vx = 0;
		if (keyCode == 38 || keyCode == 40) this.body.vy = 0;
	}
	
	private function onKeyDown(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		trace(keyCode);
		if (keyCode == 39) this.body.vx = 2;
		else if (keyCode == 37) this.body.vx = -2;
		
		if (keyCode == 38) this.body.vy = -2;
		else if (keyCode == 40) this.body.vy = 2;
		
		//jump
		if (keyCode == 32) this.body.jump(10);
	}
	
	private function loop():void 
	{
		FaceMangager.debugFace(this.spt.graphics);
		this.body.update();
		if (this.body.face)
			this.body.face.debugDraw(this.spt.graphics, "#0000ff");
	}
}
}