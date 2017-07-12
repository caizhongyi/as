package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.IComposite;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.Pause;

public class Animation extends AnimationCore implements ISingleAnimatable, IVisitorElement, IComposite {	
	
	private var childsArr:Array;
	private var childsTimesArr:Array;
	private var myPausesObj:Object;
	private var start:Number;
	private var end:Number;
	private var durationChild:Object;
	private var callbackFunc:Function;
	private var multipleValues:Boolean = false;	
	
	public function Animation() {
		super();
		this.childsArr = new Array();
		this.childsTimesArr = new Array();
		this.myPausesObj = new Object();
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
		var percentage:Number;
		if(isNaN(end)) {
			isGoto = true;
			end = start;
			start = 0;
			percentage = end;
		} else {
			isGoto = false;
			this.setStartValue(start);	
			this.setEndValue(end);			
		}
		
		this.myAnimator = new Animator();
		this.myAnimator.startPercent = start;
		this.myAnimator.endPercent = end;
		
		this.setTweening(true);
		this.start = start;
		this.end = end;
		var myPause_loc:Pause;

		this.durationChild = this.getDurationChild();
		/*invoke all childs according to their start time in childsTimesArr.*/
		var i:Number, len:Number = this.childsArr.length;	
		for (i = 0; i < len; i++) {
			var child:IAnimatable = this.childsArr[i];
			var childStart:Number = childsTimesArr[i].start;
			var childEnd:Number = childsTimesArr[i].end;			
			var isChildEndNotDefined : Boolean = isNaN(childEnd);
			var isChildEndBiggerThanSpecifiedDuration : Boolean = (childEnd > this.duration && !isNaN(this.duration));
			if(isChildEndNotDefined || isChildEndBiggerThanSpecifiedDuration) {				
				childEnd = this.duration;
			}
			
			if(isGoto) {
				var childStartPerc:Number = childStart / this.duration * 100;
				var childEndPerc:Number = childEnd / this.duration * 100;
				var totalPerc:Number = childEndPerc - childStartPerc;
			
				if(childStartPerc < percentage && childEndPerc > percentage) {
					child.setCurrentPercentage((percentage - childStartPerc) / totalPerc * 100);
				} else if(childStartPerc < percentage && childEndPerc <= percentage) {
					child.setCurrentPercentage(100);
				} else if(childStartPerc >= percentage && childEndPerc >= percentage) {
					child.setCurrentPercentage(0);
				}
				
			} else {
				
				if(childStart == 0) {
					this.invokeAnimationInstance(child, childEnd - childStart);
				} else {				
					myPause_loc = new Pause();
					var ID:Number = myPause_loc.getID();
					if(this.getTweenMode() == AnimationCore.INTERVAL) {		
						myPause_loc.waitMS(childStart, 
											invokeAnimationInstance, 
											[child, childEnd - childStart, ID]);
					} else if(this.getTweenMode() == AnimationCore.FRAMES) {
						if(this.getDurationMode() == AnimationCore.MS) {
							myPause_loc.waitFrames(APCore.milliseconds2frames(childStart), 
													invokeAnimationInstance, 
													[child, childEnd - childStart, ID]);
						} else {
							myPause_loc.waitFrames(childStart, 
												invokeAnimationInstance, 
												[child, childEnd - childStart, ID]);
						}
					}
					this.myPausesObj[ID] = myPause_loc;
				}			
			}			
		}
		
		if(isGoto) {
			if(percentage <= 0) {								
				this.dispatchEvent(new AnimationEvent(AnimationEvent.START, this.getStartValue()));
			} else if(percentage >= 100) {								
				this.dispatchEvent(new AnimationEvent(AnimationEvent.END, this.getEndValue()));				
			} else {
				this.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, this.getCurrentValue()));			
			}		
		} else {
			this.dispatchEvent(new AnimationEvent(AnimationEvent.START, this.getStartValue()));
		}		
	}

	private function getDurationChild():Object {
		var longestDuration:Number = 0;
		var longestDurationChild:Number;
		var childNum:Number = NaN;
		var i:Number, len:Number = this.childsArr.length;	
		for (i = 0; i < len; i++) {
			var child:IAnimatable = this.childsArr[i];
			var childStart:Number = childsTimesArr[i].start;
			var childEnd:Number = childsTimesArr[i].end;
			if(isNaN(childEnd)) {
				childNum = i;
			} else {
				if(childEnd >= longestDuration) {
					longestDurationChild = i;
					longestDuration = childEnd;
				}
			}			
		}

		if(isNaN(this.duration)) {			
			this.duration = longestDuration;			
			this.callbackFunc = this.invokeCallback
			durationChild = this.childsArr[longestDurationChild];
			durationChild.addEventListener(AnimationEvent.END, callbackFunc);
			return null;
		}

		var durationChild:Object;
		if(isNaN(childNum)) {			
			var myPause_loc:Pause;
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				myPause_loc = new Pause(AnimationCore.MS,this.duration, invokeCallback);
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {
					myPause_loc = new Pause(AnimationCore.FRAMES,APCore.getFPS() * this.duration, invokeCallback);
				} else {
					myPause_loc = new Pause(AnimationCore.FRAMES,this.duration,invokeCallback);
				}
			}
			durationChild = this.myPausesObj[myPause_loc.getID()] = myPause_loc;
			durationChild.animate(0,100);
		} else {			
			this.callbackFunc = this.invokeCallback;
			durationChild = this.childsArr[childNum];
			durationChild.addEventListener(AnimationEvent.END, callbackFunc);
		}
		durationChild.addEventListener(AnimationEvent.UPDATE, onUpdate);
		return durationChild;
	}
	
	private function invokeAnimationInstance(child:Object, duration:Number, ID:Number = -1):void {
		if(ID < 0)
			delete this.myPausesObj[ID];
		child.duration = duration;
		child.animate(this.start, this.end);
	}	

	override public function animationStyle(duration:Number, easing:* = null):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].animationStyle(duration, easing);
		}
		super.animationStyle(duration, easing);
	}
	
	public function onUpdate(eventObject:Object):void {
		this.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, this.getCurrentValue()));
	}	
	
	public function invokeCallback(event:AnimationEvent = null):void {
		if(this.isTweening()) {
			this.durationChild.removeEventListener(AnimationEvent.END, this.callbackFunc);
			delete this.myPausesObj[this.durationChild.getID()];
			this.stop();
			this.setTweening(false);
			this.dispatchEvent(new AnimationEvent(AnimationEvent.END, this.getEndValue()));
		}
	}

	public function addChild(component:IAnimatable, start:Number = 0, end:Number = -1):IAnimatable {
		this.childsArr.push(component);
		if(end < 0) {
			end = NaN;
		}
		this.childsTimesArr.push({start:start, end:end});
		return component;
	}
	
	public function removeChild(component:IAnimatable):void {		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			if(this.childsArr[i] == component) {
				this.childsArr.splice(i, 1);
				this.childsTimesArr.splice(i, 1);
			}
		}
	}
	
	public function getChildren():Array {
		return this.childsArr;
	}	

	override public function accept(visitor:IVisitor):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			visitor.visit(this.childsArr[i]);			
		}
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
			var child:String;
			for (child in this.myPausesObj) {
				this.myPausesObj[child].stop();
			}
			return true;
		} else {
			return false;
		}
		return true;
	}	

	override public function pause(duration:Number = 0):Boolean {
		if(super.pause(duration) == true) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].pause();				
			}			
			var child:String;
			for (child in this.myPausesObj) {
				this.myPausesObj[child].pause();
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
			var child:String;
			for (child in this.myPausesObj) {			
				this.myPausesObj[child].resume();
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
		return this.getCurrentPercentage();
	}	

	override public function getCurrentPercentage():Number {
		if(this.durationChild != null) {
			return this.durationChild.getCurrentPercentage();
		} else {
			return 0;
		}
	}	

	override public function getDurationElapsed():Number {
		return this.durationChild.getDurationElapsed();
	}
	
	override public function getDurationRemaining():Number {
		return this.durationChild.getDurationRemaining();
	}	
}
}