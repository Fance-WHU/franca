/*******************************************************************************
 * Copyright (c) 2012 itemis AG (http://www.itemis.de).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.franca.core

import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.franca.core.franca.FArrayType
import org.franca.core.franca.FContract
import org.franca.core.franca.FEnumerationType
import org.franca.core.franca.FInterface
import org.franca.core.franca.FModel
import org.franca.core.franca.FModelElement
import org.franca.core.franca.FStateGraph
import org.franca.core.franca.FStructType
import org.franca.core.franca.FTypeCollection
import org.franca.core.franca.FTypeDef
import org.franca.core.franca.FUnionType
import org.franca.core.franca.FType
import org.franca.core.franca.FEventOnIf
import org.franca.core.franca.FMethod

class FrancaModelExtensions {
	
	def static getModel (EObject obj) {
		getParentObject(obj, typeof(FModel))
	}
	
	def static getTypeCollection (EObject obj) {
		getParentObject(obj, typeof(FTypeCollection))
	}
	
	def static getInterface (EObject obj) {
		getParentObject(obj, typeof(FInterface))
	}
	
	def static getStateGraph (EObject obj) {
		getParentObject(obj, typeof(FStateGraph))
	}
	
	def static getContract (EObject obj) {
		getParentObject(obj, typeof(FContract))
	}
	
	def private static <T extends EObject> getParentObject (EObject it, Class<T> clazz) {
		var x = it
		
		do {
			x = x.eContainer
			if (clazz.isInstance(x))
				return x as T
		} while (x!=null)
		
		return null
	}
	
	def static getTriggeringMethod(FEventOnIf event) {
		var FMethod result = null
		if (event != null) {
			/*if (result == null)*/ result = event.call
			if (result == null) result = event.error
			if (result == null) result = event.respond
		}
		return result;
	}
	
	def static dispatch Set<FType> getInheritationSet(Void i) {
		return emptySet
	}
	
	def static dispatch Set<FType> getInheritationSet(FType t) {
		return #{t}
	}
	
	def static Set<FInterface> getInterfaceInheritationSet(FInterface i) {
		if (i == null) return #{};
		val result = newHashSet
		result += #{i}
		result += i.base.interfaceInheritationSet
		result
	}
	
	def static dispatch Set<FType> getInheritationSet(FStructType s) {
		if (s == null) return #{};
		val Set<FType> result = newHashSet
		result += #{s}
		result += s.base.inheritationSet
		result
	}
	
	def static dispatch Set<FType> getInheritationSet(FUnionType u) {
		if (u == null) return #{};
		val Set<FType> result = newHashSet
		result += #{u}
		result += u.base.inheritationSet
		result
	}
	
	def static dispatch Set<FType> getInheritationSet(FEnumerationType e) {
		if (e == null) return #{};
		val Set<FType> result = newHashSet
		result += #{e}
		result += e.base.inheritationSet
		result
	}
	
	def static dispatch Iterable<? extends FModelElement> getAllElements(FInterface i) {
		i.interfaceInheritationSet.map[attributes + methods + broadcasts + types].flatten
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FTypeCollection c) {
		c.types
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FArrayType a) {
		a.elementType.derived.getAllElements
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FStructType s) {
		s.inheritationSet.map[(it as FStructType).elements].flatten
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FEnumerationType e) {
		e.inheritationSet.map[(it as FEnumerationType).enumerators].flatten
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FTypeDef td) {
		td.actualType.derived.getAllElements
	}

	def static dispatch Iterable<? extends FModelElement> getAllElements(FUnionType u) {
		u.inheritationSet.map[(it as FUnionType).elements].flatten
	}

	def static protected dispatch Iterable<? extends FModelElement> getAllElements(Object e) {
		throw new IllegalStateException("Unhandled parameter types: getAllElements not yet implemented for" + e)
	}

	def static protected dispatch Iterable<? extends FModelElement> getAllElements(Void e) {
		<FModelElement>emptyList
	}

}
