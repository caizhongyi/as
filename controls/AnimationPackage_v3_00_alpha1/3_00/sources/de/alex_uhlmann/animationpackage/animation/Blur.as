package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.animation.Filter;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;

public class Blur extends Filter implements IMultiAnimatable {
	
	public var filter:BlurFilter;
	private var m_quality:Number = 1;

	public function Blur(...arguments:Array) {
		if(arguments[0] is Array) {
			this.mcs = arguments[0];
		} else {
			this.mc = arguments[0];
		}
		arguments.shift();
		this.init.apply(this, arguments);
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

	override public function setStartValues(startValues:Array, optional:Boolean = false):Boolean {
		this.hasStartValues = optional ? false : true;
		
		if(startValues[0] == null) {
			startValues[0] = createEmptyFilter();
		}
		if(startValues[0] is BlurFilter) {			
			var filter:BlurFilter = startValues[0];
			
			if(this.hasStartValues) {
				this.setNonAnimatedProperties(filter);
			}
			
			return super.setStartValues([filter.blurX, filter.blurY], optional);			
		} else {
			return super.setStartValues(startValues, optional);
		}
	}
	
	override public function setEndValues(endValues:Array):Boolean {
		
		if(endValues[0] == null) {
			endValues[0] = createEmptyFilter();
		}
		if(endValues[0] is BlurFilter) {
			
			var filter:BlurFilter = endValues[0];
			this.setNonAnimatedProperties(filter);
			
			return super.setEndValues([filter.blurX, filter.blurY]);		
		} else {
			return super.setEndValues(endValues);
		}

	}
	
	private function init(...arguments:Array):void {
		if(isNaN(arguments[0])) {
			arguments.unshift(null);
		}
		if(arguments[1] is Array) {
			var values:Array = arguments[1];
			var endValues:Array = values.slice(-1);
			arguments.splice(1, 1, endValues[0]);
			this.initAnimation.apply(this, arguments);
			this.setStartValues([values[0]]);
		} else {
			this.initAnimation.apply(this, arguments);
		}
	}
	
	private function initAnimation(...arguments:Array):void {
		if(arguments.length > 2) {
			this.animationStyle(arguments[2], arguments[3]);
		} else {			
			this.animationStyle(this.duration, this.easing);
		}	
		
		this.initializeFilter(arguments[0], arguments[1]);
		
		this.setStartValues([this.filter], true);
		this.setEndValues([arguments[1]]);
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.getEndValues();
		if(this.mc != null) {
			this.initSingleMC();			
		} else {			
			this.initMultiMC();			
		}
		
		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}

		this.startInitialized = false;
	}	
	
	private function initializeFilter(filterIndex:Number, filterEnd:BlurFilter):void {		
		if(this.mc != null) {	
			
			if(isNaN(filterIndex)) {				
				
				this.filter = this.createEmptyFilter();
				this.addFilter(this.filter);
				
			} else {			
				
				//if no filter of correct type is found at filterIndex, 
				//a new filter will be created.
				this.modifyOrCreateFilter(filterIndex);
			}
			
		} else {
			
			this.filterIndex = filterIndex;
			this.filter = filterEnd;
			
		}
	}
	
	private function modifyOrCreateFilter(filterIndex:Number):void {		
		this.filter = BlurFilter(this.findFilter(filterIndex));
		this.filters = this.mc.filters;
		this.filterIndex = filterIndex;
	}
	
	private function findFilter(filterIndex:Number):BitmapFilter {
		var filter:BitmapFilter = this.mc.filters[filterIndex];
		
		var isOfCorrectType:Boolean = this.isFilterOfCorrectType(filter);
		
		if(!isOfCorrectType && filter != null) {
			this.warnOfFilterOverwrite(filterIndex);
		}
		
		if(filter == null || !isOfCorrectType) {
			filter = this.createEmptyFilter();
		}
		return filter;
	}

	private function isFilterOfCorrectType(filter:BitmapFilter):Boolean {
		return (filter is BlurFilter == true);
	}
	
	private function createEmptyFilter():BlurFilter {
		var filter:BlurFilter = new BlurFilter();
		filter.blurX = 0;
		filter.blurY = 0;
		return filter;
	}
	
	private function initSingleMC():void {
		this.myAnimator.start = this.getStartValues();
		
		if(this.getOptimizationMode() 
			&& this.myAnimator.hasEquivalents()) {
				
			this.myAnimator.setter = [[this,"setBlurX"],
								[this,"setBlurY"]];							
		} else {
			this.myAnimator.setter = [[this,"setBlur"]];	
		}
	}
	
	private function initMultiMC():void {
		var myInstances:Array = [];			
		var len:Number = this.mcs.length;
		var mcs:Array = this.mcs;
		var i:Number = len;
		while(--i>-1) {
			myInstances[i] = new Blur(mcs[i],this.filterIndex,this.filter);			
			var filter:BlurFilter = this.updateFilter(createEmptyFilter());
			myInstances[i].setNonAnimatedProperties(filter);			
		}
		this.myInstances = myInstances;

		this.myAnimator.multiStart = ["getMultiBlurXValue","getMultiBlurYValue"];
									
		this.myAnimator.multiSetter = [[this.myInstances,"setBlurX"],
									[this.myInstances,"setBlurY"]];	

	}
	
	private function updateFilter(filter:BlurFilter):BlurFilter {		
		filter.quality = this.m_quality;
		return filter;
	}	
	
	private function updateProperties(filter:BitmapFilter):void {
		this.filter = updateFilter(BlurFilter(filter));
		this.setStartValues([this.filter], true);		
	}
	
	private function setNonAnimatedProperties(filter:BlurFilter):void {
		this.quality = filter.quality;	
	}	
	
	public function getMultiBlurXValue():Number {
		return this.filter.blurX;
	}
	
	public function getMultiBlurYValue():Number {
		return this.filter.blurY;
	}
		
	public function setBlur(blurX:Number, blurY:Number):void {
		
		this.filter.blurX = blurX;
		this.filter.blurY = blurY;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}

	public function setBlurX(blurX:Number):void {		
		this.filter.blurX = blurX;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setBlurY(blurY:Number):void {		
		this.filter.blurY = blurY;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function get quality():Number {
		return this.m_quality;
	}
	
	public function set quality(quality:Number):void {
		this.filter.quality = quality;
		this.m_quality = quality;
	}
}
}