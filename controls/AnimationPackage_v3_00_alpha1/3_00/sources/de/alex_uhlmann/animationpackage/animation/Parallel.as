package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

public class Parallel extends AnimationCore implements ISingleAnimatable, IVisitorElement, IComposite {	

	private var childsArr:Array;
	private var oneChild:*;
	
	public function Parallel() {
		super();
		this.childsArr = new Array();
	}
	
	public function run(...arguments:Array):void {
		this.invokeAnimation(0, 100);		
	}

	public function animate(start:Number, end:Number):void {		
		this.invokeAnimation(start, end);
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		
		var isGoto:Boolean;
		if(isNaN(end)) {
			isGoto = true;
			end = start;
			start = 0;
		} else {
			isGoto = false;
			this.setStartValue(start);	
			this.setEndValue(end);
		}

		var i:Number, len:Number = this.childsArr.length;
		var child:*;
		for (i = 0; i < len; i++) {
			child = this.childsArr[i];
			if(isGoto == false) {
				child.animate(start, end);
			} else {
				child.setCurrentPercentage(end);
			}
			if(child.duration == this.duration) {
				this.oneChild = child;
			}
		}

		this.oneChild.addEventListener(AnimationEvent.UPDATE, onUpdate);
		this.oneChild.addEventListener(AnimationEvent.END, onEnd);
		this.myAnimator = this.oneChild.myAnimator;
		this.setTweening(true);
		this.dispatchEvent(new AnimationEvent(AnimationEvent.START, this.getStartValue()));
	}	

	override public function animationStyle(duration:Number, easing:* = null):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {					
			this.childsArr[i].animationStyle(duration, easing);			
		}
		this.duration = duration;
	}	
	
	public function onStart(event:AnimationEvent):void {		
		this.dispatchEvent(new AnimationEvent(AnimationEvent.START, this.getStartValue()));
	}
	
	public function onUpdate(event:AnimationEvent):void {
		this.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, this.getCurrentValue()));
	}
	
	public function onEnd(event:AnimationEvent):void {			
		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child.isTweening()) {
				child.addEventListener(AnimationEvent.END, onEnd);
				return;
			}
		}
		this.setTweening(false);
		event.currentTarget.removeEventListener(AnimationEvent.END, onEnd);
		this.dispatchEvent(new AnimationEvent(AnimationEvent.END, this.getEndValue()));
	}	

	public function addChild(component:IAnimatable):IAnimatable {
		this.childsArr.push(component);
		return component;
	}

	public function removeChild(component:IAnimatable):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			if(this.childsArr[i] == component) {
				this.childsArr.splice(i, 1);
			}
		}
	}

	override public function accept(visitor:IVisitor):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			visitor.visit(this.childsArr[i]);			
		}
	}

	public function getChildren():Array {
		return this.childsArr;
	}

	override public function roundResult(rounded:Boolean):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].roundResult(rounded);		
		}
	}	

	override public function forceEnd(forceEndVal:Boolean):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].forceEnd(forceEndVal);		
		}
	}

	override public function setOptimizationMode(optimize:Boolean):void {
		this.equivalentsRemoved = optimize;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].setOptimizationMode(optimize);		
		}
	}	

	override public function setTweenMode(tweenMode:String):Boolean {
		super.setTweenMode(tweenMode);
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet = this.childsArr[i].setTweenMode(tweenMode);		
		}
		return isSet;
	}

	override public function setDurationMode(durationMode:String):Boolean {
		super.setDurationMode(durationMode);
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet = this.childsArr[i].setDurationMode(durationMode);		
		}
		return isSet;
	}

	override public function stop():Boolean {
		if(super.stop() == true) {			
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].stop();
			}
			return true;
		} else {
			return false;
		}
	}	

	override public function pause(duration:Number = 0):Boolean {		
		if(super.pause(duration) == true) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].pause();
			}
			return true;
		} else {
			return false;
		}
	}	
	
	override public function resume():Boolean {		
		if(super.resume() == true) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].resume();
			}			
			return true;
		} else {
			return false;
		}
	}	

	override public function getStartValue():Number {
		var startValue:Number = super.getStartValue();
		if(isNaN(startValue)) {
			startValue = 0;
		}
		return startValue;
	}

	override public function getEndValue():Number {
		var endValue:Number = super.getEndValue();
		if(isNaN(endValue)) {
			endValue = 100;
		}
		return endValue;
	}

	override public function getCurrentValue():Number {
		return this.oneChild.getCurrentPercentage();
	}
	
	override public function getCurrentPercentage():Number {
		return this.oneChild.getCurrentPercentage();
	}
}
}