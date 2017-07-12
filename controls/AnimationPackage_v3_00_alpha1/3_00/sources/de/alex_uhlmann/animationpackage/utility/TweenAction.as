package de.alex_uhlmann.animationpackage.utility {

import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;

/**
* Class that handles callbacks of the mx.effects.Tween and 
* 	de.alex_uhlmann.animationpackage.utility.FrameTween. 
* 	See Animator class for more details.  
*/
public class TweenAction {		

	private var scope:Object;
	private var targetStr:String;
	private var identifier:*;
	private var ref:Animator;
	private var len:Number;
	/*relaxed type to accommodate numbers or arrays*/
	private var initVal:Object;
	private var endVal:Object;
	private var singleMode:Boolean;

	public function TweenAction(ref:Animator, startVal:Object, endVal:Object) {
		this.ref = ref;
		this.initVal = initVal;
		this.endVal = endVal;		
	}	
		
	public function initSingleMode(scope:Object, targetStr:String, identifier:*):void {
		this.scope = scope;
		this.targetStr = targetStr;
		this.identifier = identifier;
		this.singleMode = true;	
	}
	
	public function initMultiMode(len:Number):void {
		this.scope = scope;
		this.targetStr = targetStr;
		this.identifier = identifier;
		this.len = len;
		this.singleMode = false;
	}	
	
	/* Optimized, less readable code. See m */
	public function o(v:Number):void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;
		var f:Function = this.identifier;
		if(f is Function) {
			p[t](v);
		} else {
			p[t] = v;
		}
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	/*onTweenUpdateOnce with rounded values to integers*/
	public function o2(v:Number):void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;
		var f:Function = this.identifier;		
		v = Math.round(v);
		if(f is Function) {
			p[t](v);
		} else {
			p[t] = v;			
		}
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	/* Optimized, less readable code.
	* o = onTweenUpdateOnce
	* m = onTweenUpdateMulitple
	* r = reference to Animator class.
	* s = setter: (Array) setter property from Animator class.
	* p = object, scope: first element of setter property from Animator class.
	* t = targetString: second element of setter property from Animator class.
	* f = function: identifier. Combination of o and t. 
	* v = value parameter.
	* u = onUpdateOnce
	* w = onUpdateMultiple
	*/	
	public function m(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		var i:Number = this.len;
		while(--i>-1) {
			p = s[i][0];
			t = s[i][1];
			f = p[t];			
			if(typeof(f) != "number") {
				p[t](v[i]);
			} else {
				p[t] = v[i];
			}		
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	/*onTweenUpdateMultiple with rounded values to integers*/
	public function m2(v:Number):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			p = s[i][0];
			t = s[i][1];
			f = p[t];			
			if(typeof(f) != "number") {
				p[t](v[i]);
			} else {
				p[t] = v[i];
			}		
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	
	
	
	
	
	
	/* 
	* Same functions as above, just one row for methods only and one row for properties only. 
	* For the sake of higher performance.
	*/	
	//for properties only
	public function op(v:Number):void {	
		var p:Object = this.scope;
		var t:String = this.targetStr;			
		p[t] = v;
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	
	
	public function o2p(v:Number):void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;	
		v = Math.round(v);
		p[t] = v;
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	

	public function mp(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		while(--i>-1) {
			s[i][0][s[i][1]] = v[i];			
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	public function m2p(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			s[i][0][s[i][1]] = v[i];		
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	
	
	//for methods only
	public function om(v:Number):void {
		var p:Object = this.scope;
		var t:String = this.targetStr;		
		p[t](v);
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));	
	}	
	
	public function o2m(v:Number):void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;	
		v = Math.round(v);	
		p[t](v);
		var r:Object = this.ref;	
		r.caller.setCurrentValue(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	

	public function mm(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		while(--i>-1) {
			s[i][0][s[i][1]](v[i]);
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	public function m2m(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			s[i][0][s[i][1]](v[i]);
		}
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}
	
	
	
	
	public function mu(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		p = s[0][0];
		t = s[0][1];
		f = p[t];
		f.apply(p,v);
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	
	
	public function mu2(v:Array):void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;		
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
		}
		p = s[0][0];
		t = s[0][1];
		f = p[t];	
		f.apply(p,v);
		r.caller.setCurrentValues(v);
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE, v));
	}	
	
	/* Optimized, less readable code.	
	* e = onTweenEnd
	*/	
	public function e(v:*):void {		
		var r:Object = this.ref;
		/*
		* It is possible that time based tweening does not 
		* reach the exact end value of the animation child.
		* If the forceEndVal property is true (default), TweenAction will 
		* invoke the update function again to force the end value.
		*/
		if(r.caller.forceEndVal) {
			v = this.endVal;
			this[r.myTween.updateMethod](v);			
		} else {
			if(this.singleMode) {
				/*
				* check for closest value to be as precise as possible:
				* v = current value not set.
				* ev = targeted value. end value in theory.
				* r.caller.currentValue = current value, last value set.
				* if the overshoot (v - ev) is smaller 
				* than the difference between the targeted value 
				* and the last value set, than set the overshoot.
				* Otherwise go with the last value set.
				*/
				var ev:* = this.endVal;
				if((v - ev) < (ev - r.caller.currentValue)) {
					this[r.myTween.updateMethod](v);
					v = r.caller.currentValue;
				} else {
					if(r.caller.rounded) {						
						v = Math.round(r.caller.currentValue);
					} else {
						v = r.caller.currentValue;
					}			
				}
			} else {
				/*
				* for multiple values we always set the last value set 
				* as end value.
				*/
				v = r.caller.currentValue;
			}		
		}
		
		r.deleteAnimation();
		
		/*invoke the callback through all listeners*/
		r.caller.setTweening(false);
		r.finished = true;
		r.caller.dispatchEvent(new AnimationEvent(AnimationEvent.END, v));
	}
}
}