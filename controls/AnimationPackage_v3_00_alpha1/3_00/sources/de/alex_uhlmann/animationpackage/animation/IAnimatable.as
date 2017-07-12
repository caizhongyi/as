package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.IAnimationPackage;
import de.alex_uhlmann.animationpackage.utility.Animator;
import flash.display.Sprite;

public interface IAnimatable extends IAnimationPackage {
	function run(...arguments:Array):void;	
	function animate(start:Number, end:Number):void;
	function getCurrentPercentage():Number;
	function setCurrentPercentage(percentage:Number):void;	
	function animationStyle(duration:Number, easing:* = null):void;
	function roundResult(rounded:Boolean):void;
	function forceEnd(forceEndVal:Boolean):void;
	function getOptimizationMode():Boolean;
	function setOptimizationMode(optimize:Boolean):void;
	function getTweenMode():String;
	function setTweenMode(tweenMode:String):Boolean;
	function getDurationMode():String;
	function setDurationMode(durationMode:String):Boolean;
	function stop():Boolean;
	function pause(duration:Number = 0):Boolean;
	function resume():Boolean;
	function lock():void;
	function unlock():void;
	function isTweening():Boolean;
	function isPaused():Boolean;
	function getDurationElapsed():Number;
	function getDurationRemaining():Number;
	function get duration():Number;
	function set duration(duration:Number):void;
	function get easing():Function;
	function set easing(easing:Function):void;	
	function get myAnimator():Animator;
	function set myAnimator(myAnimator:Animator):void;
	function get movieclip():Sprite;
	function set movieclip(mc:Sprite):void;
	function get movieclips():Array;
	function set movieclips(mcs:Array):void;
}

}