package de.alex_uhlmann.animationpackage.utility {

import flash.utils.getTimer;
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
import de.alex_uhlmann.animationpackage.utility.TweenAction;
import de.alex_uhlmann.animationpackage.utility.Tween;
import de.alex_uhlmann.animationpackage.utility.TimeTween;
import de.alex_uhlmann.animationpackage.utility.FrameTween;
import flash.events.Event;
import flash.display.MovieClip;
import flash.display.Sprite;

public class Animator extends AnimationCore implements ISingleAnimatable, IMultiAnimatable {		

	public static var animations:Object;
	public var caller:Object;
	public var start:Array;
	public var end:Array;
	public var setter:Array;
	public var multiStart:Array;
	public var multiSetter:Array;
	public var myTween:Tween;
	private var startPause:Number;
	private var pausedTime:Number = 0;
	private var elapsedDuration:Number = 0;
	public var stopped:Boolean = false;
	public var finished:Boolean = false;
	private var arrayMode:Boolean;
	private var arrayLength:Number;
	/*relaxed type to accommodate numbers or arrays*/
	private var initVal:*;
	private var endVal:*;
	private var identifierToken:Number = 2;
	public var startPercent:Number;
	public var endPercent:Number;
	private var hiddenCaller:Object;
	private var perc:Number;	
	
	public function Animator() {
		super();
		this.animationStyle(AnimationCore.duration_def);
	}

	public function run(...arguments:Array):void {
				
		if (arguments.length > 0) {
			this.animationStyle(arguments[0], arguments[1]);
		} else {
			this.animationStyle(this.duration, this.easing);
		}		
		if(this.initAnimator() == false) {
			return;
		}
		this.initAnimation(0, 100);
	}

	public function animate(start:Number, end:Number):void {
		
		if(this.initAnimator() == false) {
			return;
		}
		
		this.initAnimation(start, end);
	}

	public function setCurrentPercentage(percentage:Number):void {
		
		if(this.initAnimator() == false) {
			return;
		}
		
		//percentage = Math.round(percentage);
		this.perc = percentage;
		
		/*
		* setCurrentPercentage would usually only dispatch onUpdate events. The 
		* following is done to dispatch all events depending on 
		* the state of the animation.
		* Prevent event dispatching of TweenAction 
		* with temporalily overwriting the caller property 
		* with a clone object of Animator. Fetch onUpdate events 
		* of the clone, modify them accordingly and dispatch them to the caller.
		*/
		this.hiddenCaller = this.caller;
		var hiddenAnimator:Animator = this.cloneAnimator(this);
		if(!this.caller.omitEvent) {
			hiddenAnimator.addEventListener(AnimationEvent.UPDATE, onUpdate);
		}
		this.caller = hiddenAnimator;

		this.initStartEndValues(percentage, percentage);		
		var myTweenAction:TweenAction = this.initTweenAction();
		/*this is usually done in TweenAction*/
		if(!this.arrayMode) {
			this.hiddenCaller.setCurrentValue(this.initVal);
		} else {
			this.hiddenCaller.setCurrentValues(this.initVal);
		}
			
		myTweenAction[this.retrieveSetters().update](this.initVal);	
		this.caller = this.hiddenCaller;
	}
	
	/*
	private function between(num:Number, min:Number, max:Number):Boolean {
		return (num > min && num < max);
	}
	*/
	
	private function cloneAnimator(animator:Animator):Animator {
		var cloneObj:Animator = new Animator();
		cloneObj.omitEvent = animator.omitEvent;
		cloneObj.caller = animator.caller;
		cloneObj.start = animator.start;	
		cloneObj.end = animator.end;
		cloneObj.setter = animator.setter;
		cloneObj.multiStart = animator.multiStart;
		cloneObj.multiSetter = animator.multiSetter;
		cloneObj.roundResult(animator.caller.isRounded());
		return cloneObj;
	}	

	private function onUpdate(event:AnimationEvent):void {		
		//e.target = this.hiddenCaller;
		var newEvent:AnimationEvent;
		if(this.perc == 0) {
			newEvent = new AnimationEvent(AnimationEvent.START);
			newEvent.value = event.value;
			this.dispatch(newEvent);
		} else if(this.perc == 100) {
			newEvent = new AnimationEvent(AnimationEvent.END);
			newEvent.value = event.value;
			this.dispatch(newEvent);
		} else {
			newEvent = new AnimationEvent(AnimationEvent.UPDATE);
			newEvent.value = event.value;
			this.dispatch(newEvent);	
		}	
	}

	private function dispatchOnStart():void {
		if(!this.arrayMode) {
			this.caller.setCurrentValue(this.initVal);
		} else {
			this.caller.setCurrentValues(this.initVal);
		}
		this.caller.dispatchEvent(new AnimationEvent(AnimationEvent.START, this.initVal));																						
	}
	
	private function dispatch(e:Object):void {		
		this.hiddenCaller.dispatchEvent.apply(this.hiddenCaller, [ e ]);		
	}	
	
	private function initAnimator():Boolean {
		
		//initialize caller.
		if(this.caller == null) {
			this.caller = this;
		}
		
		//check if multiple animation targets have been supplied
		if(this.multiSetter != null) {
			this.createMultiSetter(this.multiSetter);
		}
		
		//deletion of equivalent values.
		if(this.caller.equivalentsRemoved == true) {			
			if(this.splitEquivalents() == "ALL") {
				return false;
			}
		}
		if(AnimationCore.equivalentsRemoved_static == true 
						&& this.caller.equivalentsRemoved == null) {
		
			if(this.splitEquivalents() == "ALL") {
				return false;
			}
		}
		
		saveAnimation();
		
		//initialize start/end values.
		var len:Number = this.end.length;
		if(this.start.length != len) {
			return false;
		}
		this.startInitialized = false;
		if(len > 1) {
			this.arrayMode = true;
			this.initVal = this.start;
			this.endVal = this.end;
			this.setStartValues(this.initVal);
			this.setEndValues(this.endVal);
		} else {
			this.arrayMode = false;
			this.initVal = this.start[0];
			this.endVal = this.end[0];
			this.setStartValue(this.initVal);
			this.setEndValue(this.endVal);	
		}
		
		this.arrayLength = len;
		return true;
	}
	
	private function saveAnimation():void {
		if(AnimationCore.getOverwriteModes()) {
			var i:Number = this.setter.length;
			while(--i>-1) {
				var key:String = makeKey(this.setter[i]);
				if(key == "0")return;
				if(Animator.animations == null) {
					Animator.animations = new Object();
				}
				if(Animator.animations[key] != null) {
					var animation:IAnimatable = Animator.animations[key];
					animation.stop();
				}
				Animator.animations[key] = this.caller;
			}
		}
	}
	
	private function makeKey(setter:Array):String {
		var o:String;
		if(setter[0] is Sprite) {
			o = String(setter[0]);
		} else {
			if(this.caller.overwriteProperty == null) {
				return "0";
			} else {
				o = setter[0][this.caller.overwriteProperty]; 
			}
		}
		return (o + setter[1]);
	}
	
	public function deleteAnimation():void {		
		if(Animator.animations == null) {
			return;
		}
		var i:Number = this.setter.length;
		while(--i>-1) {
			var key:String = makeKey(this.setter[i]);
			if(key == "0")return;
			delete Animator.animations[key];
		}
	}
	
	/*
	* deletion of equivalent values. Returns "NONE" to indicate 
	* that zero values have been removed. "SOME" that some have been 
	* removed and "ALL" that all have been removed.
	*/
	private function splitEquivalents():String {
		/*extract values that won't animate*/
		var len:Number = this.end.length;
		var i:Number = len;		
		while(--i>-1) {
			if(this.start[i] == this.end[i]) {
				this.start.splice(i,1);
				this.end.splice(i,1);
				this.setter.splice(i,1);
			}
		}
		if(this.start.length == 0) {
			this.caller["dispatchEvent"]({type:"onEnd", target:this.caller, value: null});
			return "ALL";
		} else if(this.end.length == len) {
			return "NONE";
		} else if(this.end.length < len) {
			return "SOME";
		} else {
			return "";	
		}
	}

	public function hasEquivalents():Boolean {
		var hasEquivalentsBool:Boolean;

		var splitResult:String = simulateSplitEquivalents();
		if(splitResult == "NONE") {
			hasEquivalentsBool = false;
		} else {
			hasEquivalentsBool = true;
		}
		
		return hasEquivalentsBool;
	}
	
	private function simulateSplitEquivalents():String {
		var startLen:Number = this.start.length;
		var endLen:Number = this.end.length;
		var setterLen:Number = this.setter.length;
		var len:Number = this.end.length;
		var i:Number = len;		
		while(--i>-1) {
			if(this.start[i] == this.end[i]) {
				startLen--;
				endLen--;
				setterLen--;
			}
		}
		if(startLen == 0) {
			return "ALL";
		} else if(endLen == len) {
			return "NONE";
		} else if(endLen < len) {
			return "SOME";
		} else {
			return "";
		}
	}
	
	private function initAnimation(start:Number, end:Number):void {
		
		this.startPercent = start;
		this.endPercent = end;
		if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
			this.invokeAnimation(start, end);
		} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
			prepareForDurationMode(start, end);
		}
	}
	
	private function prepareForDurationMode(start:Number, end:Number):void {		
		if(this.caller.getDurationMode() == AnimationCore.MS) {
			prepareForDurationModeMS();
		} else if(this.caller.getDurationMode() == AnimationCore.FRAMES) {
			prepareForDurationModeFRAMES(start, end);
		}
	}
	
	private function prepareForDurationModeMS():void {		
		var fps:Number = APCore.getFPS();
		this.onFPSCalculated(fps);		
	}	
	
	private function prepareForDurationModeFRAMES(start:Number, end:Number):void {		
		this.durationInFrames = this.duration;
		this.invokeAnimation(start, end);
	}	
	
	private function onFPSCalculated(fps:Number):void {		
		/*calculate frames with fps.*/
		this.durationInFrames = APCore.milliseconds2frames(this.duration);		
		this.invokeAnimation(this.startPercent, this.endPercent);
	}

	private function invokeAnimation(start:Number, end:Number):void {
			
		this.finished = false;		
		/*important for pause/resume/stop*/
		if(this.caller == this) {
			this.myAnimator = this;
		}		
		this.caller.setTweening(true);
		
		this.initStartEndValues(start, end);
		var myTweenAction:TweenAction = this.initTweenAction();
		
		if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
			initializeTimeTween(myTweenAction);
		} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
			initializeFrameTween(myTweenAction);
		}
		
		var setterObj:Object = this.retrieveSetters();
		
		this.myTween.setTweenHandlers(setterObj.update, 
								setterObj.end);
		this.myTween.easingEquation = this.easing;
		this.myTween.start();
		this.dispatchOnStart();
	}
	
	private function initializeTimeTween(myTweenAction:TweenAction):void {
		this.myTween = new TimeTween(myTweenAction, 
								this.initVal, 
								this.endVal, 
								this.duration, 
								this.caller.easingParams);	
	}
	
	private function initializeFrameTween(myTweenAction:TweenAction):void {
		this.myTween = new FrameTween(myTweenAction, 
								this.initVal, 
								this.endVal, 
								this.durationInFrames, 
								this.caller.easingParams);
	}	
	
	private function initStartEndValues(start:Number, end:Number):void {

		if(this.arrayLength > 1) {
						
			var startValues:Array = this.getStartValues();
			var endValues:Array = this.getEndValues();			
			var startRelArr:Array = [];
			var endRelArr:Array = [];
			var i:Number;
			var len:Number = this.arrayLength;
			for(i = 0; i < len; i++) {				
				startRelArr.push(start / 100 * (endValues[i] - startValues[i]) + startValues[i]);
				endRelArr.push(end / 100 * (endValues[i] - startValues[i]) + startValues[i]);
			}
			this.initVal = startRelArr;
			this.endVal = endRelArr;			

		} else {
			
			var startValue:Number = this.getStartValue();
			var endValue:Number = this.getEndValue();		
			var dif:Number = endValue - startValue;
			var startRel:Number = start / 100 * dif + startValue;		
			var endRel:Number = end / 100 * dif + startValue;
			this.initVal = startRel;
			this.endVal = endRel;
			
		}
	}
	
	private function initTweenAction():TweenAction {
		var scope:Object = this.setter[0][0];
		var targetStr:String = this.setter[0][1];		
		var identifier:* = scope[targetStr];
		var myTweenAction:TweenAction = new TweenAction(this, 
												this.initVal, 
												this.endVal);
		if(this.arrayMode == false) {
			myTweenAction.initSingleMode(scope, targetStr, identifier);
		} else {
			myTweenAction.initMultiMode(this.arrayLength);
		}
		
		return myTweenAction;
	}
	
	private function retrieveSetters():Object {
		
		/* 
		* Choose the most suitable callback method of TweenAction.
		* Optimized, less readable code.
		* o = onTweenUpdateOnce
		* m = onTweenUpdateMulitple
		* e = onTweenEnd
		* 2 = rounds the result
		* p = only properties
		* m = only methods
		* mu = multiple parameters
		* mu2 = rounded multiple parameters
		*/
		/*first compute identifierTokens for another abstration*/
		this.computeSetters();
		
		var setterObj:Object = new Object();
		var rounded:Boolean = this.caller.isRounded();
		if(this.arrayMode == false) {			
			if(!rounded) {
				if(this.identifierToken == 0) {
					setterObj.update = "op";
				} else if(this.identifierToken == 1) {
					setterObj.update = "om";
				} else {
					setterObj.update = "o";
				}
			} else {
				if(this.identifierToken == 0) {
					setterObj.update = "o2p";
				} else if(this.identifierToken == 1) {
					setterObj.update = "o2m";
				} else {
					setterObj.update = "o2";
				}
			}			
		} else {
			if(!rounded) {				
				if(this.identifierToken == 0) {
					setterObj.update = "mp";
				} else if(this.identifierToken == 1) {
					setterObj.update = "mm";
				} else if(this.identifierToken == 2) {
					setterObj.update = "m";
				} else {
					setterObj.update = "mu";
				}
			} else {
				if(this.identifierToken == 0) {
					setterObj.update = "m2p";
				} else if(this.identifierToken == 1) {					
					setterObj.update = "m2m";
				} else if(this.identifierToken == 2) {
					setterObj.update = "m2";
				}else {
					setterObj.update = "mu2";
				}
			}
		}
		setterObj.end = "e";
		return setterObj;
	}
	
	private function computeSetters():void {
		var scope:Object = this.setter[0][0];
		var targetStr:String = this.setter[0][1];
		var identifier:* = scope[targetStr];
		/*
		* initialize TweenAction and check if either only properties, only methods or both are used. 
		* Needed for optimisation. The corresponding callback method of TweenAction 
		* will be chosen later in retrieveSetters.
		*/
		if(this.arrayMode == false) {
			this.checkIfFunction(identifier);			
		} else {
			/*
			* if there are more values to animate than setters, Animator assigns a 
			* special callback method of TweenAction, 
			* which sends all animated values to the first setter.
			*/
			if(this.setter.length < this.arrayLength) {
				this.identifierToken = 3;
			} else {		
				var i:Number = this.setter.length-1;
				var result:Boolean = this.checkIfFunction(this.setter[i][0][this.setter[i][1]]);
				while(--i>-1) {
					if(this.checkIfFunction(this.setter[i][0][this.setter[i][1]]) != result) {
						this.identifierToken = 2;
						break;
					}
				}
			}	
		}
	}
	
	/*
	* 0 = Property
	* 1 = Method
	* 2 = Both
	* 3 = multiple parameters
	*/
	private function checkIfFunction(identifier:*):Boolean {		
		if(identifier is Function) {
			this.identifierToken = 1;
			return true;
		} else {
			this.identifierToken = 0;
			return false;
		}
	}	

	private function createMultiSetter(setter:Array):void {
		/*
		* if the multiStart property is defined, Animator fills 
		* the start parameter with the return values of the methods or
		* properties of the multiStart Array.
		* This way each IAnimatable user class can present different 
		* start values to Animator for each animation target with setting 
		* the multiStart and multiSetter properties.
		*/
		var init:Boolean;
		var startVal:Array;
		var startValue:Number;
		var startTargetStr:String;
		if(this.multiStart == null) {
			init = false;
			startVal = this.start;
		} else {			
			init = true;
		}
		var s:Array = this.start = [];
		var endVal:Array = this.end;
		var endValue:Number;
		var e:Array = this.end = [];
		var se:Array = this.setter = [];
		var scopes:Array;
		var len1:Number = setter.length;	
		var i:Number = len1;
		while(--i>-1) {
			if(init) {
				startTargetStr = this.multiStart[i];
			} else {
				startValue = startVal[i];
			}
			endValue = endVal[i];
			scopes = setter[i][0];
			var targetStr:String = setter[i][1];
			var len2:Number = scopes.length;	
			var j:Number = len2;
			while(--j>-1) {
				var scope:Object = scopes[j];				
				if(init) {
					if(this.checkIfFunction(scope[startTargetStr])) {
						s.unshift(scope[startTargetStr]());
					} else {
						s.unshift(scope[startTargetStr]);
					}
				} else {
					s.unshift(startValue);					
				}
				e.unshift(endValue);
				se.unshift([scope,targetStr]);
			}			
		}	
		if(scopes.length == 0) {			
			this.caller.setStartValue(s);
			this.caller.setEndValue(e);
			this.caller.setStartValues(undefined);
			this.caller.setEndValues(undefined);
			this.caller.setCurrentValues(undefined);
		} else {
			this.caller.setStartValues(s);
			this.caller.setEndValues(e);
			this.caller.setStartValue(undefined);
			this.caller.setEndValue(undefined);
			this.caller.setCurrentValue(undefined);
		}
	}
	
	override public function getDurationElapsed():Number {		
		if(this.paused == true || this.stopped == true) {
			return this.elapsedDuration;
		} else {
			return this.computeElapsedDuration();
		}
	}
	
	override public function getDurationRemaining():Number {
		var r:Number;
		if(this.stopped == false) {
			if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
				r = this.duration - this.getDurationElapsed();
			} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
				if(this.caller.getDurationMode() == AnimationCore.MS) {	
					r = this.duration - this.getDurationElapsed();
					if(this.finished == true) {
						r = 0;
					}
				} else {
					r = this.durationInFrames - this.getDurationElapsed();
				}
			}
			if(r < 0) {
				r = 0;
			}
		} else {
			r = 0;
		}
		if(isNaN(r)) {
			return undefined;
		} else {
			return r;
		}
	}
	
	private function computeElapsedDuration():Number {
		var r:Number;
		if(this.finished == true) {
			r = this.duration;
		} else {
			if(this.myTween != null) {
				if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
					r = getTimer() - this.myTween.startTime;
				} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
					if(this.caller.getDurationMode() == AnimationCore.MS) {
						r = APCore.getFPS() * (APCore.frame - this.myTween.startTime);			
					} else {
						r = APCore.frame - this.myTween.startTime;
					}		
				}
			}
		}
		if(isNaN(r)) {
			return undefined;
		} else {
			return r;
		}
	}

	public function stopMe():void {
		this.elapsedDuration = this.computeElapsedDuration();
		deleteAnimation();
		this.stopped = true;
	}
	
	public function pauseMe():void {	
		this.elapsedDuration = this.computeElapsedDuration();
		this.myTween.pause();
	}
	
	public function resumeMe():void {
		this.myTween.resume();
	}
}

}