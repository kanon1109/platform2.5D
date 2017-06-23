package 
{
import body.Body;
import face.Surface;
import laya.display.Graphics;
import laya.display.Sprite;
import laya.events.Event;
import laya.utils.Handler;
import laya.utils.Stat;
import manager.FaceMangager;
/**
 * ...加背景地图测试
 * @author Kanon
 */
public class Platform2DTest005 
{
	public static var g:Graphics;
	private var spt:Sprite;
	private var ball:Sprite;
	private var rect:Sprite;
	private var faceArr:Array;
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var g:Number = .2;
	//刚体
	private var body:Body;
	public function Platform2DTest005() 
	{
		Laya.init(1136, 640);
		Stat.show(0, 0);
		this.spt = new Sprite();
		this.ball = new Sprite();
		this.ball.graphics.drawCircle(0, 0, 10, "#6633ff");
		g = this.spt.graphics;
		Laya.stage.addChild(this.spt);
		Laya.stage.addChild(this.ball);
		
		this.rect = new Sprite();
		this.rect.graphics.drawRect(0, 0, 10, 10, "#ff0000");
		Laya.stage.addChild(this.rect);

		Laya.loader.load("res/map.json", Handler.create(this, loadCompleteHandler));
		
		this.body = new Body();
		this.body.x = 100;
		this.body.y = 200;
		this.body.thick = 10;
		this.body.g = 0.7;
		this.body.display = ball;
		
		
		Laya.stage.on(Event.CLICK, this, onClick);
		Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
		Laya.stage.on(Event.KEY_PRESS, this, onKeyPress);
		Laya.stage.on(Event.KEY_UP, this, onKeyUp);
	}
	
	private function loadCompleteHandler():void
	{
		var json:Object = Laya.loader.getRes("res/map.json");
		FaceMangager.createFaceMap(JSON.stringify(json));
		Laya.timer.frameLoop(1, this, loop);
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
		if (this.body.face)
			this.body.face.debugDraw(this.spt.graphics, "#00FF80");
			
		if ( this.body.tempFace)
		{
			this.rect.x = this.body.tempFace.x + this.body.tempFace.upLeftPoint.x + 30;
			this.rect.y = this.body.tempFace.y + this.body.tempFace.upLeftPoint.y + 30;
		}
	}
}
}