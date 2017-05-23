package 
{
import body.Body;
import face.Surface;
import laya.display.Graphics;
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
	public static var g:Graphics;
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
		g = this.spt.graphics;
		Laya.stage.addChild(this.spt);
		Laya.stage.addChild(this.ball);
		
		this.body = new Body();
		this.body.x = 100;
		this.body.y = 200;
		this.body.thick = 10;
		this.body.display = ball;
		
		//最下层
		var startX:Number = 80;
		var gapH:Number = 21;
		var face:Surface = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "downface1";
		face.x = startX - 50;
		face.y = 280;
		face.z = 0;
		face.upBlock = true;
		face.leftBlock = true;
		face.downBlock = true;
		FaceMangager.add(face);
		
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "downface2";
		face.x = startX + 100 - 50;
		face.y = 280;
		face.z = 0;
		//face.upBlock = true;
		face.leftRestrict = true;
		face.rightBlock = true;
		face.downBlock = true;
		FaceMangager.add(face);
		
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "downface3";
		face.x = startX + 230 - 50;
		face.y = 280 + 30;
		face.z = 0;
		face.upBlock = true;
		face.rightBlock = true;
		face.downBlock = true;
		face.leftH = 30;
		FaceMangager.add(face);
		
		//中间层
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "middleface1";
		face.x = startX;
		face.y = 200;
		face.z = 1;
		face.upBlock = true;
		face.leftBlock = true;
		//face.rightBlock = true;
		//face.downBlock = true;
		FaceMangager.add(face);
		
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "middleface2";
		face.x = startX + 100;
		face.y = 230;
		face.z = 1;
		face.upBlock = true;
		face.rightBlock = true;
		face.leftH = 30;
		//face.downBlock = true;
		FaceMangager.add(face);
		
		//最上层
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "upface1";
		face.x = startX + 50;
		face.y = 120;
		face.z = 2;
		face.upBlock = true;
		//face.rightBlock = true;
		face.leftBlock = true;
		FaceMangager.add(face);
		
		//最上层
		face = new Surface(50, 0, 150, 100, 0, 50);
		face.name = "upface2";
		face.x = startX + 190;
		face.y = 120;
		face.z = 2;
		face.upBlock = true;
		face.rightBlock = true;
		//face.leftBlock = true;
		FaceMangager.add(face);
		
		Laya.stage.on(Event.CLICK, this, onClick);
		Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
		Laya.stage.on(Event.KEY_PRESS, this, onKeyPress);
		Laya.stage.on(Event.KEY_UP, this, onKeyUp);
		Laya.timer.frameLoop(20, this, loop);
	}
	
	private function onKeyPress(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
	}
	
	private function onClick(e:*=null):void 
	{
		//jump
		this.body.jump(12);
	}
	
	private function onKeyUp(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		//trace("onKeyUp", keyCode);
		if (keyCode == 68 || keyCode == 65) this.body.moveH(0);
		if (keyCode == 87 || keyCode == 83) this.body.moveV(0);
	}
	
	private function onKeyDown(e:*=null):void 
	{
		var keyCode:int = e["keyCode"];
		//trace("onKeyDown", keyCode);
		if (keyCode == 68) this.body.moveH(2);
		else if (keyCode == 65) this.body.moveH(-2);
		if (keyCode == 87) this.body.moveV(-2);
		else if (keyCode == 83) this.body.moveV(2);
		if (keyCode == 32) this.body.jump(12);
	}
	
	private function loop():void 
	{
		FaceMangager.debugFace(this.spt.graphics);
		this.body.update();
		//if (this.body.face)
			//this.body.face.debugDraw(this.spt.graphics, "#00FF80");
	}
}
}