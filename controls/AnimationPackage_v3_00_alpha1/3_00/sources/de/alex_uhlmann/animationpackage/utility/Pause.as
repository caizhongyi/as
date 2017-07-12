package de.alex_uhlmann.animationpackage.utility {

import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.getTimer;

public class Pause extends AnimationCore {
	
	private static var refs:Object;
	private var type:String;
	private var callback:Object;
	private var param:Array;
	private var timer:Timer;
	private var pauseMode:String;
	private var startTime:Number;
	private var isFirstFrame:Boolean;	
	private var elapsedDuration:Number = 0;
	private var stopped:Boolean = false;
	private var finished:Boolean = false;
	private var startPause:Number;
	private var durationPaused:Number = 0;
	private var durationOrig:Number;
	//used for invoking an onUpdate event.
	private var elapsedDurationSaved:Number = 0;
	
	public function Pause(...arguments:Array) {
		super();
		/*
		* don't let the garbage collector delete the instance 
		* if invoked only via constructor. Save a reference.
		*/
		if(Pause.refs == null) {
			Pause.refs = new Object();
		}
		Pause.refs[this.getID()] = this;
		
		if(arguments.length > 0) {			
			this.init.apply(this, arguments);
		}
	}
	
	private function init(...arguments:Array):void {		
		
		if(arguments.length == 0) {
			return;
		}
		
		this.type = arguments[0];
		var duration:Number = arguments[1];
		this.callback = arguments[2];
		this.param = arguments[3];
		
		if(this.type == AnimationCore.MS) {
			this.duration = this.durationOrig = duration;		
		} else if(this.type == AnimationCore.FRAMES) {
			this.duration = this.durationOrig = Math.round(duration);		
		}
	}
	
	private function invokeAnimation(start:Number, end:Number):void {		
		this.startInitialized = false;
		
		if(this.type == AnimationCore.MS) {				
			if(!isNaN(end )) {
				start = start / 100 * this.duration;
				this.startTime = getTimer() + start;
				end = end / 100 * this.duration;
				this.duration = end;
				this.paused = false;
				this.isFirstFrame = true;
				this.initMSInterval();
				APCore.getAnimationClip().addEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
			} else {
				start = start / 100 * this.duration;
				this.paused = true;
				this.elapsedDuration = start;
				this.dispatchUpdate();
			}			
		} else if(this.type == AnimationCore.FRAMES) {				
			if(!isNaN(end)) {
				start = start / 100 * this.duration;
				this.startTime = APCore.frame + start;
				end = end / 100 * this.duration;
				this.duration = end;
				this.paused = false;
				this.isFirstFrame = true;			
				this.initFramesInterval();
				APCore.getAnimationClip().addEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
			} else {
				start = start / 100 * this.duration;
				this.paused = true;
				this.elapsedDuration = start;
				this.dispatchUpdate();
			}
		}
	}
	
	public function run(...arguments:Array):void {		
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);		
	}

	public function animate(start:Number, end:Number):void {		
		this.invokeAnimation(start, end);
	}
	
	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}	
	
	public function onEnterFrameUpdate(event:Event):void {
		if((this.startTime + APCore.frame) >= this.duration && this.type == AnimationCore.FRAMES) {
			this.clearFRAMESPause();
		}
		dispatchUpdate();
	}
	
	public function dispatchUpdate():void {
		var durationElapsed:Number = this.getDurationElapsed();
		if(this.elapsedDurationSaved != durationElapsed) {			
			if(this.isFirstFrame) {
				this.isFirstFrame = false;
				this.dispatchEvent(new AnimationEvent(AnimationEvent.START));
			} else if(this.finished) {
				this.dispatchEvent(new AnimationEvent(AnimationEvent.END));
			} else {
				this.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE));
			}
		}
		this.elapsedDurationSaved = durationElapsed;
	}
	
	public function waitMS(milliseconds:Number, callback:Object, param:Array = null):void {
		this.init(AnimationCore.MS, 
					milliseconds,
					callback, 
					param);
					
		this.invokeAnimation(0,100);
	}
	
	private function initMSInterval():void {
		this.pauseMode = AnimationCore.INTERVAL;
		this.setTweening(true);
		this.finished = false;
		this.timer = new Timer(this.duration);
		this.timer.addEventListener(TimerEvent.TIMER, clearMSPause);
		this.timer.start();		
	}
	
	public function waitFrames(frames:Number, callback:Object, param:Array = null):void {
		this.init(AnimationCore.FRAMES, 
					frames, 
					callback, 
					param);
					
		this.invokeAnimation(0,100);
	}
	
	private function initFramesInterval():void {
		this.pauseMode = AnimationCore.FRAMES;		
		this.setTweening(true);
		this.finished = false;
	}
	
	private function clearMSPause(event:TimerEvent):void {
		this.timer.reset();		
		APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
		this.invokeCallback(this.callback, this.param);
	}
	
	private function clearFRAMESPause():void {
		APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
		this.invokeCallback(this.callback, this.param);
	}
		
	private function invokeCallback(callback:Object,
									param:Array):void {
	
		this.setTweening(false);
		this.finished = true;
		this.callback.apply(this, param);
		this.dispatchEvent(new AnimationEvent(AnimationEvent.END));
		delete Pause.refs[this.getID()];
	}
	
	override public function stop():Boolean {
		if(super.stop() == true) {
			this.stopped = true;
			this.elapsedDuration = this.computeElapsedDuration();
			if(this.pauseMode == AnimationCore.INTERVAL) {				
				this.timer.reset();
			} else if(this.pauseMode == AnimationCore.FRAMES) {				
				APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
			}
			return true;
		} else {
			return false;
		}
	}
	
	/*
	* pause would be an illegal identifier, 
	* because Pause is the class and Flash Player 6 
	* cannot differ lower and upper cases at runtime.
	*/
	override public function pause(duration:Number = 0):Boolean {
		if(super.pause(duration) == false) {			
			return false;
		}
		this.paused = true;
		this.elapsedDuration = this.computeElapsedDuration();	
		if(this.pauseMode == "INTERVAL") {
			this.startPause = getTimer();
			this.timer.stop();
		} else if(this.pauseMode == "FRAMES") {			
			this.startPause = APCore.frame;			
		}
		APCore.getAnimationClip().removeEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
		return true;
	}
	
	override public function resume():Boolean {
		if(this.locked == true) {
			return false;
		} else {
			this.setTweening(true);
			this.paused = false;
			this.duration -= this.elapsedDuration;
			if(this.getTweenMode() == AnimationCore.INTERVAL) {				
				this.durationPaused += getTimer() - this.startPause;
				this.initMSInterval();
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				this.durationPaused += APCore.frame - this.startPause;
				this.initFramesInterval();
			}
			APCore.getAnimationClip().addEventListener(Event.ENTER_FRAME, onEnterFrameUpdate);
			return true;
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
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				r = this.durationOrig - this.getDurationElapsed();
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {	
					r = this.durationOrig - this.getDurationElapsed();
					if(this.finished == true) {
						r = 0;
					}
				} else {
					r = this.durationOrig - this.getDurationElapsed();
				}
			}			
			if(r < 0) {
				r = 0;
			}
		} else {
			r = 0;
		}
		return r;
	}
	
	private function computeElapsedDuration():Number {
		if(this.finished == true) {
			return this.durationOrig;
		} else {		
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				return getTimer() - this.startTime - this.durationPaused;
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {
					return APCore.getFPS() * (APCore.frame - this.startTime - this.durationPaused);			
				} else {
					return APCore.frame - this.startTime - this.durationPaused;
				}		
			}
		}
		return 0;
	}
	
	override public function getStartValue():Number {
		return 0;
	}
	
	override public function getEndValue():Number {		
		return this.durationOrig;
	}	
	
	override public function getCurrentValue():Number {		
		return this.getDurationElapsed();
	}
	
	override public function getCurrentPercentage():Number {		
		return this.getDurationElapsed() / this.durationOrig * 100;
	}
}
}