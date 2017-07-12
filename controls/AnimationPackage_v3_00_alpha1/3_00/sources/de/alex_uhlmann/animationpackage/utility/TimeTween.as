package de.alex_uhlmann.animationpackage.utility {

import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.utils.getTimer;
import flash.utils.setInterval;
import flash.utils.clearInterval;
import de.alex_uhlmann.animationpackage.utility.Tween;
import de.alex_uhlmann.animationpackage.utility.TimeTween;

/**
* Time-based tween engine. 
* 				
*/
public class TimeTween extends Tween {		
	
	private static var activeTweens:Array = new Array();
	private static var interval:Number = 10;
	private static var startPauseAll:Number;	
	private static var timer:Timer;
	
	private static function addTween(tween:TimeTween):void {
		tween.id = TimeTween.activeTweens.length;
		TimeTween.activeTweens.push(tween);
		if (TimeTween.timer == null) {
			TimeTween.timer = new Timer(TimeTween.interval);
			TimeTween.timer.addEventListener(TimerEvent.TIMER, TimeTween.dispatch);
			TimeTween.timer.start();
		}	
	}
	
	private static function removeTweenAt(index:Number):void {
		var tweens:Array = TimeTween.activeTweens;

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
			TimeTween.timer.reset();
			TimeTween.timer = undefined;
		}
	}
	
	private static function dispatch(event:TimerEvent):void {		
		var tweens:Array = TimeTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;		
		for (i = 0; i < len; i++) {
			var tween:TimeTween = tweens[i];
			if(tween != null)
				tween.doInterval();
		}
		event.updateAfterEvent();
	}
	
	public static function pauseAll():void {
		TimeTween.startPauseAll = getTimer();
		if(TimeTween.timer == null)
			return;
		TimeTween.timer.stop();
		var tweens:Array = TimeTween.activeTweens;		
		var i:Number = tweens.length;
		while(--i > -1) {
			var tween:TimeTween = tweens[i];
			if(tween == null)
				continue;
			tween.isTweening = false;
		}
	}
	
	public static function resumeAll():void {		
		if(TimeTween.timer == null)
			return;		
		TimeTween.timer.start();
		var tweens:Array = TimeTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;
		for (i = 0; i < len; i++) {
			var tween:TimeTween = tweens[i];
			if(tween == null)
				continue;	
			if( !tween.isTweening ) {
				tween.startTime += (getTimer() - TimeTween.startPauseAll);
			}
			tween.isTweening = true;
		}
	}
	
	public function TimeTween(listener:Object, 
							  start:Object, end:Object, duration:Number, 
							  easingParams:Array) {
		
		super(listener, start, end, duration, easingParams);		
	}	

	public function start():void {	
		if(easingEquation == null) {
			easingEquation = defaultEasingEquation;
		}
		startTime = getTimer();
		if (this.duration == 0) {
			endTween(endValue);
		} else {
			TimeTween.addTween(this);
		}
		this.isTweening = true;
	}
	
	public function stop():void {		
		TimeTween.removeTweenAt(this.id);
		this.isTweening = false;
	}
	
	public function pause():void {		
		this.startPause = getTimer();
		delete TimeTween.activeTweens[this.id];
		this.isTweening = false;
	}
	
	public function resume():void {
		this.startTime += (getTimer() - startPause);		
		TimeTween.activeTweens[this.id] = this;
		this.isTweening = true;
	}
	
	public function doInterval():void {
		var curTime:Number = getTimer() - startTime;
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