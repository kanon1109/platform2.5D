package 
{
import face.Surface;
import laya.display.Graphics;
import laya.display.Sprite;
import laya.display.Stage;
import laya.utils.Stat;
/**
 * ...面的左右限制位置和范围
 * @author Kanon
 */
public class Platform2DTest001 
{
	private var spt:Sprite;
	private var spt2:Sprite;
	private var face:face.Surface;
	public function Platform2DTest001() 
	{
		Laya.init(1136, 640);
		//Stat.show(0, 0);
		this.face = new face.Surface(50, 0, 150, 100, 0, 100);
		this.face.x = 100;
		this.face.y = 100;
		
		this.spt = new Sprite();
		this.spt2 = new Sprite();
		Laya.stage.addChild(this.spt);
		Laya.stage.addChild(this.spt2);
		Laya.timer.frameLoop(1, this, loop);
		this.face.debugDraw(this.spt.graphics);
	}
	
	private function loop():void 
	{
		var g:Graphics = this.spt2.graphics;
		g.clear();
		var leftX:Number = this.face.getLeftRange(Laya.stage.mouseY);
		var rightX:Number = this.face.getRightRange(Laya.stage.mouseY);
		
		g.drawLine(0, Laya.stage.mouseY, 500, Laya.stage.mouseY, "#ff00ff");
		g.drawLine(leftX, 0, leftX,	500, "#ffccff");
		g.drawLine(rightX, 0, rightX,	500, "#cc66ff");
		
		trace("inHorizontalRange", this.face.inVerticalRange(Laya.stage.mouseY));
		trace("inUpRange", this.face.inUpRange(Laya.stage.mouseX));
		trace("inDownRange", this.face.inDownRange(Laya.stage.mouseX));
	}
}
}