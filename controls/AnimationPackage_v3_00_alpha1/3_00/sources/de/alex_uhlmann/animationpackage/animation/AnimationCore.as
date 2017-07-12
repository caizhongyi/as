package de.alex_uhlmann.animationpackage.animation {
	
import com.robertpenner.easing.*;

import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.FrameTween;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.Pause;
import de.alex_uhlmann.animationpackage.utility.TimeTween;

import flash.display.Sprite;

public class AnimationCore extends APCore implements IVisitorElement {	
	
	public static var duration_def:Number = 1000;
	public static var easing_def:Function = Linear.easeNone;
	public static var INTERVAL:String = "INTERVAL";
	public static var FRAMES:String = "FRAMES";	
	public static var MS:String = "MS";
	private static var tweenModes:String = AnimationCore.INTERVAL;
	private static var durationModes:String = AnimationCore.MS;
	private static var overwriteModes:Boolean = true;
	protected static var equivalentsRemoved_static:Boolean = false;	
	private var _duration:Number;
	private var _easing:Function;
	private var _myAnimator:Animator;	
	//used to flag animations not to dispatch events. Used by Animator.
	public var omitEvent:Boolean = false;	
	public var easingParams:Array = null;
	protected var durationInFrames:Number;
	protected var startInitialized:Boolean = false;
	private var startValue:Number;
	private var startValues:Array;
	private var endValue:Number;
	private var endValues:Array;
	private var currentValue:Number;
	private var currentValues:Array;	
	protected var mc:Sprite;
	protected var mcs:Array;
	private var tweenMode:String = null;
	private var durationMode:String = null;	
	public var equivalentsRemoved:Boolean = false;
	public var overwriteProperty:String;
	private var rounded:Boolean = false;
	public var forceEndVal:Boolean = true;	
	protected var locked:Boolean = false;	
	private var myPause:Pause;
	private var tweening:Boolean = false;
	public var paused:Boolean = false;

	public function AnimationCore() {
		super.registerInstance();	
	}
		
	public function accept(visitor:IVisitor):void {
		visitor.visit(this);
	}

	public function getStartValue():Number {
		return this.startValue;
	}
	
	public function setStartValue(startValue:Number, optional:Boolean = false):Boolean {
		if(this.startInitialized == false || optional != true) {			
			this.startInitialized = true;	
			this.startValue = startValue;
			return true;
		}
		return false;
	}	
	
	public function getStartValues():Array {
		return this.startValues;
	}
	
	public function setStartValues(startValues:Array, optional:Boolean = false):Boolean {
		if(this.startInitialized == false || optional != true) {			
			this.startInitialized = true;			
			this.startValues = startValues;			
			return true;
		}
		return false;
	}
	
	public function getEndValue():Number {		
		return this.endValue;
	}
	
	public function setEndValue(endValue:Number):Boolean {
		this.endValue = endValue;
		return true;
	}	
	
	public function getEndValues():Array {		
		return this.endValues;
	}
	
	public function setEndValues(endValues:Array):Boolean {		
		this.endValues = endValues;
		return true;
	}		
	
	public function getCurrentValue():Number {		
		return this.currentValue;
	}
	
	public function setCurrentValue(currentValue:Number):void {		
		this.currentValue = currentValue;
	}
	
	public function getCurrentValues():Array {		
		return this.currentValues;
	}
	
	public function setCurrentValues(currentValues:Array):void {		
		this.currentValues = currentValues;
	}
	
	public function getCurrentPercentage():Number {
		var start:Number;
		var end:Number;
		var current:Number;
		
		// if any values is null, AnimationCore assumes 
		// that the animation has not yet started and therefore returns 0%.
		
		if(isNaN(this.startValue)) {
			
			// if start and end values are the same during animation
			// it's impossible to compute the current percentage.
			// Therefore, only compute values that have different start 
			// and end values.
					
			var startValues:Array = this.getStartValues();
			if(startValues == null) {
				return 0;
			}
			var endValues:Array = this.getEndValues();
			if(endValues == null) {
				return 0;
			}
			var i:Number = startValues.length;
			while(--i>-1) {
				if(startValues[i] != endValues[i]) {					
					break;
				}
			}
			start = startValues[i];			
			end = endValues[i];
			if(this.getCurrentValues()[i] != null) {
				current = this.getCurrentValues()[i];
			} else {
				return 0;
			}
		} else {
			if(!isNaN(this.getStartValue())) {
				start = this.getStartValue();
			} else {
				return 0;
			}
			if(!isNaN(this.getEndValue())) {
				end = this.getEndValue();
			} else {
				return 0;
			}
			if(!isNaN(this.getCurrentValue())) {
				current = this.getCurrentValue();
			} else {
				return 0;
			}
		}
		
		if(start < end) {
			return (current - start) / (end - start) * 100;
		} else {
			return 100 - ((current - end) / (start - end) * 100);
		}
	}
	
	public function getDurationElapsed():Number {		
		return this.myAnimator.getDurationElapsed();
	}
	
	public function getDurationRemaining():Number {
		return this.myAnimator.getDurationRemaining();
	}
	
	//animationStyle, getter, setter
	public function animationStyle(duration:Number, easing:* = null):void {
		if (easing == null) {
			this.easing = AnimationCore.easing_def;
		} else if (easing is Array) {
			this.easing = easing[0];
			this.easingParams = easing.slice(1);
		} else {
			this.easing = easing;
		}
		this.duration = (isNaN(duration)) ? AnimationCore.duration_def : duration;	
	}
	
	public function get duration():Number {
		return this._duration;
	}
	
	public function set duration(duration:Number):void {
		this._duration = duration;
	}
	
	public function get easing():Function {
		return this._easing;
	}
	
	public function set easing(easing:Function):void {
		this._easing = easing;
	}	
	
	public function get myAnimator():Animator {
		return this._myAnimator;
	}
	
	public function set myAnimator(myAnimator:Animator):void {
		this._myAnimator = myAnimator;
	}
	
	public function get movieclip():Sprite {
		return this.mc;
	}
	
	public function set movieclip(mc:Sprite):void {
		this.mc = mc;
	}
	
	public function get movieclips():Array {
		return this.mcs;
	}
	
	public function set movieclips(mcs:Array):void {
		this.mcs = mcs;
	}
	
	public function isRounded():Boolean {
		return this.rounded;
	}
	
	//deprecated
	public function checkIfRounded():Boolean {
		return this.rounded;
	}	
	
	public function roundResult(rounded:Boolean):void {
		this.rounded = rounded;
	}
	
	public function forceEnd(forceEndVal:Boolean):void {
		this.forceEndVal = forceEndVal;
	}
	
	public function getOptimizationMode():Boolean {		
		return this.equivalentsRemoved;
	}
	
	public function setOptimizationMode(optimize:Boolean):void {		
		this.equivalentsRemoved = optimize;
	}

	public static function getOptimizationModes():Boolean {
		return AnimationCore.equivalentsRemoved_static;
	}

	public static function setOptimizationModes(optimize:Boolean):void {
		AnimationCore.equivalentsRemoved_static = optimize;
	}

	public function getTweenMode():String {
		if(this.tweenMode == null) {
			return AnimationCore.tweenModes;
		} else {
			return this.tweenMode;
		}
	}
	
	public function setTweenMode(tweenMode:String):Boolean {
		if(tweenMode == AnimationCore.INTERVAL) {
			this.tweenMode = tweenMode;
			this.durationMode = AnimationCore.MS;
		} else if(tweenMode == AnimationCore.FRAMES) {
			this.tweenMode = tweenMode;
			this.durationMode = AnimationCore.FRAMES;
		} else {
			return false;
		}
		return true;
	}

	public static function getTweenModes():String {
		return AnimationCore.tweenModes;
	}
	
	public static function setTweenModes(t:String):Boolean {
		if(t == AnimationCore.INTERVAL) {
			AnimationCore.tweenModes = t;
			AnimationCore.durationModes = AnimationCore.MS;
		} else if(t == AnimationCore.FRAMES) {
			AnimationCore.tweenModes = t;
			AnimationCore.durationModes = AnimationCore.FRAMES;
		} else {
			return false;
		}
		return true;
	}
	
	public function getDurationMode():String {
		if(this.durationMode == null) {
			return AnimationCore.durationModes;
		} else {
			return this.durationMode;
		}
	}
		
	public function setDurationMode(durationMode:String):Boolean {
		
		var isTweenModeFrames:Boolean = (this.getTweenMode() == AnimationCore.FRAMES);
		var isDurationModeValid:Boolean = (durationMode == AnimationCore.MS || durationMode == AnimationCore.FRAMES);
		
		if(isTweenModeFrames && isDurationModeValid) {
			this.durationMode = durationMode;
			return true;
		}
		return false;
	}	

	public static function getDurationModes():String {		
		return AnimationCore.durationModes;
	}	

	public static function setDurationModes(d:String):Boolean {		
		
		var isTweenModeFrames:Boolean = (AnimationCore.tweenModes == AnimationCore.FRAMES);
		var isDurationModeValid:Boolean = (d == AnimationCore.MS || d == AnimationCore.FRAMES);
				
		if(isTweenModeFrames && isDurationModeValid) {
			AnimationCore.durationModes = d;
			return true;
		}
		return false;
	}

	public static function getOverwriteModes():Boolean {
		return AnimationCore.overwriteModes;
	}	

	public static function setOverwriteModes(overwriteModes:Boolean):void {
		AnimationCore.overwriteModes = overwriteModes;
	}

	public static function pauseAll():void {
		//time based tweening.
		TimeTween.pauseAll();
		//frame based tweening.
		FrameTween.pauseAll();
	}

	public static function resumeAll():void {		
		//time based tweening.
		TimeTween.resumeAll();
		//frame based tweening.
		FrameTween.resumeAll();
	}
	
	public function isTweening():Boolean {		
		return this.tweening;
	}
	
	public function setTweening(isTweening:Boolean):void {		
		this.tweening = isTweening;
	}	
	
	public function isPaused():Boolean {
		return this.paused;
	}
	
	public function stop():Boolean {
		if(this.locked == true || this.tweening == false) {
			this.paused = false;
			return false;
		} else {
			this.tweening = false;
			this.paused = false;
			if(this.myAnimator == null)
				return true;
			if(this.myAnimator.myTween == null)
				return true;
			this.myAnimator.stopMe();
			return true;
		}
	}	
	
	public function pause(duration:Number = 0):Boolean {
		if(this.locked == true || this.tweening == false) {			
			return false;
		} else {	
			this.tweening = false;
			this.paused = true;	
			if(this.myAnimator == null)
				return true;
			this.myAnimator.paused = true;	
			if(this.myAnimator.myTween == null)
				return true;
			if(duration > 0) {
				if(this.myPause == null) {
					this.myPause = new Pause();
				} else {
					this.myPause.stop();
				}
				if(this.getTweenMode() == AnimationCore.INTERVAL) {
					this.myPause.waitMS(duration, resume);
				} else if(this.getTweenMode() == AnimationCore.FRAMES) {
					if(this.getDurationMode() == AnimationCore.MS) {
						duration = APCore.milliseconds2frames(duration);
					}
					this.myPause.waitFrames(duration, resume);
				}
			}
			this.myAnimator.pauseMe();
			return true;
		}
	}
	
	public function resume():Boolean {
		if(this.myAnimator == null)
				return true;
		if(this.locked == true || this.myAnimator.paused == false) {
			return false;
		} else {
			this.tweening = true;
			this.paused = false;
			this.myAnimator.paused = false;
			if(this.myAnimator.myTween == null)
				return true;
			this.myAnimator.resumeMe();
			return true;
		}
	}	
	
	public function lock():void {		
		if(this.locked == false) {
			this.locked = true;
		}
	}
	
	public function unlock():void {		
		if(this.locked == true) {
			this.locked = false;
		}
	}
}
}
