package de.alex_uhlmann.animationpackage.utility {

import flash.geom.Point;

/**
* Offers common used methods for bezier curves.
*/
public class BezierToolkit 
{			
	/**
	* Returns a point on a quadratic bezier curve with Robert Penner's optimization 
	*				of the standard equation:
	* @param targ (Number)
	* @param p1 (Point)
	* @param p2 (Point)
	* @param p3 (Point)
	*/
	/*Adapted from Robert Penner.*/
	public function getPointsOnQuadCurve(t:Number, p1:Point, p2:Point, p3:Point):Point {
		var v:Number = t / 100;
		var p:Point = new Point();
		p.x = p1.x + v*(2*(1-v)*(p2.x-p1.x) + v*(p3.x - p1.x));
		p.y = p1.y + v*(2*(1-v)*(p2.y-p1.y) + v*(p3.y - p1.y));	
		return p;
	}
	
	/**
	* @param targ (Number)
	* @param p1 (Point)
	* @param p2 (Point)
	* @param p3 (Point)
	* @param p4 (Point)
	*/	
	/*Adapted from Paul Bourke.*/
	public function getPointsOnCubicCurve(targ:Number, p1:Point, p2:Point, p3:Point, p4:Point):Point {
		var a:Number,b:Number,c:Number;	
		var v:Number = targ / 100;	
		a = 1 - v;
		b = a * a * a;
		c = v * v * v;
		var p:Point = new Point();
		p.x = b * p1.x + 3 * v * a * a * p2.x + 3 * v * v * a * p3.x + c * p4.x;
		p.y = b * p1.y + 3 * v * a * a * p2.y + 3 * v * v * a * p3.y + c * p4.y;		
		return p;
	}
	
	/**
	* @param targ (Number)
	* @param startX (Number)
	* @param startY (Number)
	* @param x2 (Number)
	* @param y2 (Number)
	* @param endX (Number)
	* @param endY (Number)
	*/
	/*Adapted from Robert Penner's drawCurve3Pts() method*/
	public function getQuadControlPoints(startX:Number, startY:Number, 
						        x2:Number, y2:Number, 
						        endX:Number, endY:Number):Point {
							        
		var c:Point = new Point();
		c.x = (2 * x2) - .5 * (startX + endX);
		c.y = (2 * y2) - .5 * (startY + endY);        
		return c;
	}	
	
	/**
	* if anybody finds a generic method to compute control points 
	* for bezier curves with n control points, 
	* if only the points on the curve are given, please let me know!
	* @param targ (Number)
	* @param startX (Number)
	* @param startY (Number)
	* @param throughX1 (Number)
	* @param throughY1 (Number)
	* @param throughX2 (Number)
	* @param throughY2 (Number)
	* @param endX (Number)
	* @param endY (Number)
	*/	
	public function getCubicControlPoints(startX:Number, startY:Number, 
						        throughX1:Number, throughY1:Number, 
									throughX2:Number, throughY2:Number, 
						        endX:Number, endY:Number):Object {
		
		var c:Object = new Object();
		c.x1 = -(10 * startX - 3 * endX - 8 * (3 * throughX1 - throughX2)) / 9;
		c.y1 = -(10 * startY - 3 * endY - 8 * (3 * throughY1 - throughY2)) / 9;
		c.x2 = (3 * startX - 10 * endX - 8 * throughX1 + 24 * throughX2) / 9;
		c.y2 = (3 * startY - 10 * endY - 8 * throughY1 + 24 * throughY2) / 9;
		return c;
	}
	
	/*
	* de.alex_uhlmann.animationpackage.drawing.CubicCurve needs to access this method.
	* Adapted from Paul Bourke.
	*/
	public function getPointsOnNCurve(targ:Number, points:Array):Point {
		var v:Number = targ / 100;
		var k:Number, kn:Number, nn:Number, nkn:Number, blend:Number, muk:Number, munk:Number;
		var p:Array = points;
		var n:Number = points.length - 1;
		var b:Point = new Point();
		if(v != 1) {
			//calculate for all control points 
			//but the last point on the path
			muk = 1;		
			munk = Math.pow(1 - v, n);		
			for (k = 0; k <= n; k++) {			
				nn = n;
				kn = k;
				nkn = n - k;			
				blend = muk * munk;			
				muk *= v;
				munk /= (1 - v);			
				while (nn >= 1) {
					blend *= nn;				
					nn--;
					if (kn > 1) {
						blend /= kn;
						kn--;
					}
					if (nkn > 1) {
						blend /= nkn;
						nkn--;
					}
				}
				b.x += p[k].x * blend;
				b.y += p[k].y * blend;		
			}
			return b;
		} else {
		//Calculate the last point 
		//- it is NOT a control point
			var l:Number = p.length - 1;
			b.x = p[l].x;
			b.y = p[l].y;
			return b;
		}
	}	
}

}