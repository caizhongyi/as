package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
import de.alex_uhlmann.animationpackage.animation.SequenceEvent;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

public class Sequence extends AnimationCore implements ISingleAnimatable, IVisitorElement, IComposite {	
	
	public static const JOIN:String = "JOIN";
	public static const EACH:String = "EACH";
	
	private var childsArr:Array;
	private var start:Number;
	private var end:Number;
	private var currentChild:IAnimatable;
	private var childDuration:Number;
	private var position:Number = 1;
	private var animateMode:String = "JOIN";
	private var roundedPosStart:Number;
	private var roundedPosEnd:Number;
	private var percentages:Array;
	private var backwards:Boolean = false;
	private var elapsedDuration:Number = 0;
	private var sequenceArr:Array;
	
	public function Sequence() {
		super();
		this.childsArr = new Array();
		this.sequenceArr = new Array();
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
		var child:IAnimatable;
		if(isNaN(end)) {
			isGoto = true;
			percentage = end = start;
			start = 0;			
		} else {
			isGoto = false;
			this.start = start;
			this.end = end;
			this.setTweening(true);
		}
		
		this.myAnimator = new Animator();
		this.myAnimator.startPercent = start;
		this.myAnimator.endPercent = end;
		
		var i:Number, len:Number = this.childsArr.length;		
		var fChild:IAnimatable;
		
		var posStart:Number = start / 100 * len;
		var posEnd:Number = end / 100 * len;
			
		this.setStartValue(posStart);
		this.setEndValue(posEnd);
		
		
		if(this.animateMode == Sequence.JOIN) {			

			if(!isGoto) {
			
				var details:Object = this.getAnimateDetails(start, end, this.childsArr);
				this.backwards = details.backwards;
				this.position = details.position;			
				var roundedPosStart:Number = details.roundedPosStart;
				var roundedPosEnd:Number = details.roundedPosEnd;
				this.percentages = details.percentages;			
			
				fChild = this.currentChild = this.childsArr[roundedPosStart];
				fChild.animate(this.percentages[this.position-1].start, 
								this.percentages[this.position-1].end);	
									
			} else {
				
				if(percentage < 0) {
					this.invokeAnimation(0, NaN);
					return;
				} else if(percentage > 100) {
					this.invokeAnimation(100, NaN);
					return;
				}
				var posPerc:Number = percentage / 100 * (len-1);
				var roundedPosPerc:Number = Math.floor(posPerc);
				var perc_loc:Number = (posPerc - roundedPosPerc) * 100;
				this.position = roundedPosPerc + 1;
				this.currentChild = this.childsArr[roundedPosPerc];
								
				for (i = 0; i < len; i++) {
					child = this.childsArr[i];
					if(i < roundedPosPerc) {
						child.setCurrentPercentage(100);
					} else {
						child.setCurrentPercentage(0);
					}
				}
				
				this.childsArr[roundedPosPerc].setCurrentPercentage(perc_loc);

				if(percentage == 0) {					
					this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
									this.getStartValue(),
									this.childDuration));
				} else if(percentage == 100) {
					this.dispatchEvent(new SequenceEvent(AnimationEvent.END, 
									this.getEndValue(),
									this.childDuration));
				} else {
					this.dispatchEvent(new SequenceEvent(AnimationEvent.UPDATE, 
									this.getCurrentValue(),
									this.childDuration));
				}

			}
			
		} else {			
			
			this.percentages = new Array();
			this.position = 1;
			for (i = 0; i < len; i++) {
				child = this.childsArr[i];
				this.sequenceArr.push(this.childsArr[i+1]);
				child.addEventListener(AnimationEvent.UPDATE, onUpdate);
				child.addEventListener(AnimationEvent.END, onEnd);
				this.percentages[i] = {start:start, end:end};
			}	
			fChild = this.currentChild = this.childsArr[0];			
			if(isGoto == false) {
				if(start > end) {
					this.backwards = true;				
				} else {
					this.backwards = false;
				}
				fChild.animate(start, end);
			} else {			
				fChild.setCurrentPercentage(percentage);
			}
		}
		if(!isGoto) {
			this.childDuration = fChild.duration;
			this.elapsedDuration = 0;
			this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
															this.getStartValue(),
															this.childDuration,
															null,
															fChild));
		}
	}

	private function getAnimateDetails(start:Number, 
									end:Number, 
									childsArr:Array):Object {
		
		var backwards:Boolean;
		if(start > end) {
			backwards = true;				
		} else {
			backwards = false;
		}
		/*			
		* To compute start and end values for all childs combined, 
		* I first compute the childs where the tween will start and end. (rule of three)
		* The integer part of the number posStart and posEnd represents that.
		* The fractional part of those numbers represent the percentage to be animated in integer child.
		*/
		var i:Number, len:Number = this.childsArr.length;
		var posStart:Number = start / 100 * (len);
		var posEnd:Number = end / 100 * (len);
		
		var roundedPosStart:Number = Math.floor(posStart);
		var roundedPosEnd:Number = Math.floor(posEnd);			
		var start_loc:Number;
		if(posStart > roundedPosStart) {				
			start_loc = (posStart - roundedPosStart) * 100;					
		} else {
			if(backwards) {
				roundedPosStart--;
				start_loc = 100;
			} else {					
				start_loc = 0;
			}
		}			
		var end_loc:Number;
		if(posEnd > roundedPosEnd) {				
			end_loc = (posEnd - roundedPosEnd) * 100;					
		} else {				
			if(backwards) {
				end_loc = 0;
			} else {
				roundedPosEnd--;
				end_loc = 100;
			}
		}
		
		this.position = roundedPosStart+1;
		
		var child:Object;
		//apply animate state to all children.			
		for (i = 0; i < len; i++) {
			child = this.childsArr[i];
			child.omitEvent = true;
			if(backwards) {
				if(i > roundedPosStart) {
					child.setCurrentPercentage(0);
				} else {
					child.setCurrentPercentage(100);
				}
			}
			child.omitEvent = false;
		}		
		for (i = len-1; i > -1; i--) {
			child = this.childsArr[i];
			child.omitEvent = true;
			if(!backwards) {
				if(i < roundedPosStart) {
					child.setCurrentPercentage(100);
				} else {
					child.setCurrentPercentage(0);
				}
			}
			child.omitEvent = false;
			child.addEventListener(AnimationEvent.UPDATE, onUpdate);
		}

		
		//reset succossors.
		this.sequenceArr = new Array();
		
		var percentages:Array = new Array();
		//for forward tweening
		for (i = roundedPosStart; i < roundedPosEnd; i++) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i+1]);
			child.addEventListener(AnimationEvent.END, onEnd);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:100};
			} else {
				percentages[i] = {start:0, end:100};
			}
		}
		//for backward tweening
		for (i = roundedPosStart; i > roundedPosEnd; i--) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i-1]);
			child.addEventListener(AnimationEvent.END, onEnd);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:0};
			} else {
				percentages[i] = {start:100, end:0};
			}
		}
		child = childsArr[roundedPosEnd];
		child.addEventListener(AnimationEvent.END, onEnd);
		if(backwards) {
			percentages[roundedPosEnd] = {start:100, end:end_loc};
		} else {
			percentages[roundedPosEnd] = {start:0, end:end_loc};
		}
		
		var details:Object = new Object();
		details.backwards = backwards;
		details.position = roundedPosStart+1;
		details.roundedPosStart = roundedPosStart;
		details.roundedPosEnd = roundedPosEnd;		
		details.percentages = percentages;		
		return details;
	}
	
	public function onStart(event:AnimationEvent):void {	
		this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
						this.getStartValue(),
						this.childDuration));
	}	
	
	public function onUpdate(event:AnimationEvent):void {	
		this.dispatchEvent(new SequenceEvent(AnimationEvent.UPDATE, 
						this.getCurrentValue(),
						this.childDuration));
	}
	
	public function onEnd(event:AnimationEvent):void {
		
		event.currentTarget.removeEventListener(AnimationEvent.END, onEnd);
		var successor:IAnimatable = this.sequenceArr.shift();
		if(successor == null) {
			this.setTweening(false);
			
			this.dispatchEvent(new SequenceEvent(AnimationEvent.END, 
									this.getEndValue(),
									NaN,
									IAnimatable( event.target ),
									null));

		} else {
			/*backwards will only be true in Sequence mode JOIN*/
			if(this.animateMode == Sequence.JOIN && this.backwards) {
				this.position--;
			} else {
				this.position++;
			}
			this.elapsedDuration += event.target.getDurationElapsed();
			this.currentChild = successor;
			this.childDuration = successor.duration;
														
			this.dispatchEvent(new SequenceEvent(SequenceEvent.UPDATE_POSITION, 
															this.getCurrentValue(),
															this.childDuration,
															IAnimatable(event.target),
															successor));
			
			successor["animate"].apply(successor, [this.percentages[this.position-1].start, 
												this.percentages[this.position-1].end]);
		}		
	}

	override public function animationStyle(duration:Number, easing:* = null):void {
		super.animationStyle(duration, easing);
		var i:Number, len:Number = this.childsArr.length;
		var dividedDuration:Number = this.childDuration = duration / len;
		for (i = 0; i < len; i++) {
			this.childsArr[i].animationStyle(dividedDuration, easing);					
		}
	}

	public function setAnimateMode(animateMode:String):Boolean {
		if(animateMode == Sequence.EACH || animateMode == Sequence.JOIN) {	
			this.animateMode = animateMode;
		} else {
			return false;
		}
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:* = this.childsArr[i];
			if(child is Sequence) {
				child.setAnimateMode(animateMode);
			}
		}
		return true;	
	}

	public function getAnimateMode():String {
		return this.animateMode;
	}
	
	public function getChild():IAnimatable {		
		return IAnimatable(this.currentChild);
	}

	public function getChildren():Array {
		return this.childsArr;
	}

	public function getNextChild():IAnimatable {
		if(this.animateMode == Sequence.JOIN && this.backwards) {
			return IAnimatable(this.childsArr[this.position-2]);
		} else {
			return IAnimatable(this.childsArr[this.position]);
		}
	}

	public function getPreviousChild():IAnimatable {		
		if(this.animateMode == Sequence.JOIN && this.backwards) {
			if(this.position-1 == this.childsArr.length) {
				return IAnimatable(this.childsArr[this.position-1]);
			} else {
				return IAnimatable(this.childsArr[this.position]);
			}			
		} else {
			return IAnimatable(this.childsArr[this.position-2]);
		}
	}

	public function getChildDuration():Number {		
		return this.childDuration;
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
	
	override public function accept(visitor:IVisitor):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			visitor.visit(this.childsArr[i]);			
		}
	}

	override public function stop():Boolean {		
		var success:Boolean = this.getChild().stop();
		if(success) {
			this.setTweening(false);
			this.paused = false;
			
			this.dispatchEvent(new SequenceEvent(AnimationEvent.END, 
									this.getEndValue(),
									NaN,
									null,
									this.getChild()));										
		}
		return success;
	}	

	override public function pause(duration:Number = 0):Boolean {		
		var success:Boolean = this.getChild().pause(duration);
		if(success) {
			this.setTweening(false);
			this.paused = true;
		}
		return success;		
	}	

	override public function resume():Boolean {	
		var success:Boolean = this.getChild().resume();
		if(success) {
			this.setTweening(true);
			this.paused = false;
		}
		return success;
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
		return this.position;
	}
	
	override public function getCurrentPercentage():Number {
		var pos:Number = this.getCurrentValue()-1;
		var perc:Number = this.currentChild.getCurrentPercentage();
		if(isNaN(perc)) {
			perc = 0;			
		}
		if(this.animateMode == Sequence.EACH && this.backwards == true) {
			pos = this.getEndValue() - (pos - (this.getStartValue() - 1));
		}
		var currentValue:Number = pos + perc / 100;
		var currentPerc:Number = currentValue / (this.childsArr.length) * 100;		
		return currentPerc;
	}

	override public function getDurationElapsed():Number {
		return this.elapsedDuration + this.currentChild.getDurationElapsed();
	}

	override public function getDurationRemaining():Number {
		return this.duration - this.getDurationElapsed();
	}
}
}