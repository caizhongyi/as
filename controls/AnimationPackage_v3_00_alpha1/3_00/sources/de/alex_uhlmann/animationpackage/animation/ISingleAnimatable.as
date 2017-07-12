package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.IAnimatable;

public interface ISingleAnimatable extends IAnimatable {
	function getStartValue():Number;
	function setStartValue(startValue:Number, optional:Boolean = false):Boolean;
	function getCurrentValue():Number;
	function getEndValue():Number;
	function setEndValue(endValue:Number):Boolean;
}

}