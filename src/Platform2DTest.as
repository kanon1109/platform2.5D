package 
{
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
		Stat.show(0, 0);
		var face:Surface = new Surface();
		face.width = 200;
		face.height = 100;
		face.leftSkew = 60;
		trace(face.getLeftRange(50));
		trace("inini")
	}
}
}