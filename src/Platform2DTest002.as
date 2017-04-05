package 
{
import face.Surface;
import laya.display.Sprite;
import laya.events.Event;
/**
 * ...两个面的链接
 * @author Kanon
 */
public class Platform2DTest002 
{
	private var spt:Sprite;
	private var ball:Sprite;
	private var faceArr:Array;
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var g:Number = .2;
	private var curFace:Surface;
	public function Platform2DTest002() 
	{
		Laya.init(1136, 640);
		this.spt = new Sprite();
		this.ball = new Sprite();
		this.ball.graphics.drawCircle(0, 0, 3, "#6633ff");
		this.ball.x = 150;
		this.ball.y = 150;
		this.faceArr = [];
		Laya.stage.addChild(this.spt);
		Laya.stage.addChild(this.ball);
		var startX:Number = 80;
		for (var i:int = 0; i < 3; i++) 
		{
			var face:Surface = new Surface(50, 0, 150, 100);
			face.x = 100 * i + startX;
			face.y = 100;
			if (i == 2) 
			{
				face.x = startX - 50;
				face.y = 200;
			}
			this.faceArr.push(face);
		}
		this.curFace = this.faceArr[0];
		Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
		Laya.stage.on(Event.KEY_UP, this, onKeyUp);
		Laya.timer.frameLoop(1, this, loop);
	}
	
	private function onKeyUp(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		if (keyCode == 39 || keyCode == 37) this.vx = 0;
		if (keyCode == 38 || keyCode == 40) this.vy = 0;

	}
	
	private function onKeyDown(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		if (keyCode == 39) this.vx = 2;
		else if (keyCode == 37) this.vx = -2;
		
		if (keyCode == 38) this.vy = -2;
		else if (keyCode == 40) this.vy = 2;
	}
	
	private function updateFace():void
	{
		this.spt.graphics.clear();
		var count:int = this.faceArr.length;
		for (var i:int = 0; i < count; i++) 
		{
			var face:Surface = this.faceArr[i];
			face.debugDraw(this.spt.graphics);
		}
	}
	
	private function updateMouse():void
	{
		this.ball.x += this.vx;
		this.ball.y += this.vy;
		if(!this.curFace) this.vy += this.g;
	}
	
	private function loop():void 
	{
		this.updateFace();
		this.updateMouse();
	}
}
}