package de.alex_uhlmann.animationpackage.utility {

import flash.events.Event;
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.Tween;

/**
* Frame-based tween engine. 
* 	FrameTween uses André Michelle's FrameBasedInterval and ImpulsDispatcher classes 
* 	for efficient frame tweening. Frame based tweening is faster and more accurate than time based tweening.
*/
public class FrameTween extends Tween {		
	
	private static var activeTweens:Array = new Array();
	private static var startPauseAll:Number;	
	private static var isRunning : Boolean = false;
	
	private static function addTween(tween:FrameTween):void {
		tween.id = FrameTween.activeTweens.length;
		activeTweens.push(tween);	
		if (!FrameTween.isRunning) {
			APCore.getAnimationClip().addEventListener(Event.ENTER_FRAME, FrameTween.dispatch);
			isRunning = true;
		}
	}
	
	private static function removeTweenAt(index:Number):void {		
		var tweens:Array = FrameTween.activeTweens;
		if(index >= tweens.length || index < 0 || isNaN(index)) {
			return;
		}		
		tweens.splice(index, 1);
		var i:Number;
		var len:Number = tweens.length;
		for (i = index; i < len; i++) {
			tweens[i].id--;
		}
		if (len == 0) {
			APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, FrameTween.dispatch);
			FrameTween.isRunning = false;
		}
	}
	
	private static function dispatch(event:Event):void {
		var tweens:Array = FrameTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;		
		for (i = 0; i < len; i++) { 
			var tween:FrameTween = tweens[i];
			if(tween != null)
				tween.doInterval();
		}
	}

	public function FrameTween(listener:Object, 
							  start:Object, end:Object, duration:Number, 
							  easingParams:Array) {			
		
		super(listener, start, end, duration, easingParams);
	}
	
	public function start():void {			
		if(easingEquation == null) {
			easingEquation = defaultEasingEquation;
		}
		if (this.duration == 0) {
			endTween(endValue);
		} else {				
			FrameTween.addTween(this);
		}
		this.startTime = APCore.frame;
		this.isTweening = true;
	}
	
	public function stop():void {
		FrameTween.removeTweenAt(this.id);
		this.isTweening = false;
	}
	
	public function pause():void {
		this.startPause = APCore.frame;
		delete FrameTween.activeTweens[this.id];
		this.isTweening = false;
	}
	
	public function resume():void {
		var pausedTime:Number = APCore.frame - this.startPause;
		this.startTime += pausedTime;
		FrameTween.activeTweens[this.id] = this;
		this.isTweening = true;
	}		
	
	public static function pauseAll():void {
		FrameTween.startPauseAll = APCore.frame;
		APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, FrameTween.dispatch);
		var tweens:Array = FrameTween.activeTweens;
		var i:Number = tweens.length;
		while(--i > -1) {
			var tween:FrameTween = tweens[i];
			if(tween == null)
				continue;
			tween.isTweening = false;
		}
	}
	
	public static function resumeAll():void {		
		APCore.getAnimationClip().addEventListener(Event.ENTER_FRAME, FrameTween.dispatch);
		var tweens:Array = FrameTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;
		for (i = 0; i < len; i++) {
			var tween:FrameTween = tweens[i];
			if(tween == null)
				continue;
			if( !tween.isTweening ) {
				tween.startTime += (APCore.frame - FrameTween.startPauseAll);
			}
			tween.isTweening = true;
		}
	}	
	
	private function doInterval():void {
		var curTime:Number = APCore.frame - startTime;			
		var curVal:Object;
		if(easingParams == null) {
			curVal = getCurVal(curTime);
		} else {
			curVal = getCurVal2(curTime);
		}
		if (curTime >= duration) {			
			endTween(curVal);
			this.stop();
		} else {
			if (updateMethod != null) {
				listener[updateMethod](curVal);
			} else {
				listener.onTweenUpdate(curVal);
			}
		}
	}
}
}