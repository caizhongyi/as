package de.alex_uhlmann.animationpackage.utility {

import de.alex_uhlmann.animationpackage.utility.IVisitorElement;

public interface IVisitor {
	function visit(visitorElement:IVisitorElement):void;
}

}