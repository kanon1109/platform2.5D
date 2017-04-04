package 
{
import laya.display.Graphics;
import laya.display.Sprite;
import laya.display.Stage;
import laya.utils.Stat;
/**
 * ...测试类
 * @author Kanon
 */
public class Platform2DTest 
{
	public function Platform2DTest() 
	{
		Laya.init(1136, 640);
		//Stat.show(0, 0);
		var face:Surface = new Surface(100, 0, 200, 100);
		trace(face.getLeftRange(50));
		
		var spt:Sprite = new Sprite();
		var g:Graphics = spt.graphics;
		Laya.stage.addChild(spt);
		
		
		g.drawLine(face.upLeftPoint.x, 
					face.upLeftPoint.y,
					face.upRightPoint.x,
					face.upRightPoint.y, 
					"#ff0000");
					
		g.drawLine(face.upLeftPoint.x, 
					face.upLeftPoint.y,
					face.downleftPoint.x,
					face.downleftPoint.y, 
					"#ff0000");
					
		g.drawLine(face.downleftPoint.x, 
					face.downleftPoint.y,
					face.downRightPoint.x,
					face.downRightPoint.y, 
					"#ff0000");
		
		g.drawLine(face.upRightPoint.x, 
					face.upRightPoint.y,
					face.downRightPoint.x,
					face.downRightPoint.y, 
					"#ff0000");
					
					
		g.drawLine(0, 50,
					300,
					50, 
					"#ff00ff");
	}
}
}