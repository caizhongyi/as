////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2005 Macromedia, Inc. All Rights Reserved.
//  The following is Sample Code and is subject to all restrictions
//  on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package com.robertpenner.easing
{

/**
 *  The Sine class defines three easing functions to implement 
 *  motion with Flex effect classes, where the motion is defined by 
 *  a sine wave.
 *
 *  For more information, see http://www.robertpenner.com/profmx.
 */  
public class Sine
{
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

    /**
     *  The <code>easeIn()</code> method starts motion from zero velocity, 
     *  and then accelerates motion as it executes. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeIn(t:Number, b:Number,
								  c:Number, d:Number):Number
	{
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
	}

    /**
     *  The <code>easeOut()</code> method starts motion fast, 
     *  and then decelerates motion to a zero velocity as it executes. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeOut(t:Number, b:Number,
								   c:Number, d:Number):Number
	{
		return c * Math.sin(t / d * (Math.PI / 2)) + b;
	}

    /**
     *  The <code>easeInOut()</code> method combines the motion
     *  of the <code>easeIn()</code> and <code>easeOut()</code> methods
	 *  to start the motion from a zero velocity, accelerate motion, 
	 *  then decelerate to a zero velocity. 
     *
     *  @param t Specifies time.
	 *
     *  @param b Specifies the initial position of a component.
	 *
     *  @param c Specifies the total change in position of the component.
	 *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     */  
	public static function easeInOut(t:Number, b:Number,
									 c:Number, d:Number):Number
	{
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
	}
}

}
