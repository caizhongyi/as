package de.alex_uhlmann.animationpackage.utility {

import flash.geom.ColorTransform;
import flash.display.Sprite;

/**
* Offers some color effect methods.
* 			<p>
* 			Example 1: Sets the movieclip mc to a negative color value.	
* 			<blockquote><pre>
*			var myColorFX:ColorFX = new ColorFX(mc);
*			myColorFX.setNegative(255);	
*			</pre></blockquote>
* 			<p>
* @param mc (MovieClip) Movieclip to animate. 
*/
public class ColorFX
{
	public var target:Sprite;
	
	public function ColorFX(target:Sprite)
	{
		this.target = target;
	}
	
	//adapted color_toolkit.as by Robert Penner
	public function getBrightness():Number {
		var trans:ColorTransform = target.transform.colorTransform;
		return trans.redOffset ? 1 - trans.redMultiplier : trans.redMultiplier - 1;		
	}

	// bright between -1 and 1
	public function setBrightness(bright:Number):void {			
		trace(bright);
		var trans:ColorTransform = target.transform.colorTransform;
		trans.redMultiplier = trans.greenMultiplier = trans.blueMultiplier = 1 - Math.abs(bright); // color percent
		trans.redOffset = trans.greenOffset = trans.blueOffset = (bright > 0) ? bright * (256/1) : 0; // color offset
		target.transform.colorTransform = trans;
	}

	public function getNegative():Number {
		var trans:ColorTransform = target.transform.colorTransform;
		return trans.redOffset * (100/255);
	}

	// produce a negative image of the normal appearance
	public function setNegative(percent:Number):void {
		var trans:ColorTransform = target.transform.colorTransform;
		trans.redMultiplier = trans.greenMultiplier = trans.blueMultiplier = 1 - .02 * percent;
		trans.redOffset = trans.greenOffset = trans.blueOffset = percent * (255/100);
		target.transform.colorTransform = trans;
	}
}

}