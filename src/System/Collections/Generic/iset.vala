// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  ISet
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic sets.
**
** 
===========================================================*/
namespace System.Collections.Generic {

    using System;
    using System.Runtime.CompilerServices;


    /// <summary>
    /// Generic collection that guarantees the uniqueness of its elements, as defined
    /// by some comparer. It also supports basic set operations such as Union, Intersection, 
    /// Complement and Exclusive Complement.
    /// </summary>
    public interface ISet<T> : Gee.Set<T>, ICollection<T> {

        //Add ITEM to the set, return true if added, false if duplicate
        public virtual bool Add(T value) {
			return add(value);
		}
		
        //Transform this set so it contains no elements that are also in other
        public abstract void ExceptWith(IEnumerable<T> other);

        //Transform this set into its intersection with the IEnumberable<T> other
        public abstract void IntersectWith(IEnumerable<T> other);

        //Check if this set is a subset of other, but not the same as it
        public abstract bool IsProperSupersetOf(IEnumerable<T> other);

        //Check if this set is a superset of other, but not the same as it
        public abstract bool IsProperSubsetOf(IEnumerable<T> other);

        //Check if this set is a subset of other
        public abstract bool IsSubsetOf(IEnumerable<T> other);

        //Check if this set is a superset of other
        public abstract bool IsSupersetOf(IEnumerable<T> other);

        //Check if this set has any elements in common with other
        public abstract bool Overlaps(IEnumerable<T> other);

        //Check if this set contains the same and only the same elements as other
        public abstract bool SetEquals(IEnumerable<T> other);

        //Transform this set so it contains elements initially in this or in other, but not both
        public abstract void SymmetricExceptWith(IEnumerable<T> other);
        
        //Transform this set into its union with the IEnumerable<T> other
        public abstract void UnionWith(IEnumerable<T> other);

    }

}
