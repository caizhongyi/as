package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.IAnimatable;

public interface IMultiAnimatable extends IAnimatable {
	function getStartValues():Array;
	function setStartValues(startValues:Array, optional:Boolean = false):Boolean;
	function getCurrentValues():Array;
	function getEndValues():Array;
	function setEndValues(endValues:Array):Boolean;	
}

}