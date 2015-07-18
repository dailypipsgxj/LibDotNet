// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IEnumerator
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for all generic enumerators.
**
** 
===========================================================*/
namespace System.Collections.Generic {    
    using System;
    using System.Runtime.InteropServices;

    // Base interface for all generic enumerators, providing a simple approach
    // to iterating over a collection.
    public interface IEnumerator<T> : GLib.Object
    {    
        // Returns the current element of the enumeration. The returned value is
        // undefined before the first call to MoveNext and following a
        // call to MoveNext that returned false. Multiple calls to
        // GetCurrent with no intervening calls to MoveNext 
        // will return the same object.
        // 
        public abstract T Current { owned get; }
        public abstract T get ();
        // Interfaces are not serializable
        // Advances the enumerator to the next element of the enumeration and
        // returns a boolean indicating whether an element is available. Upon
        // creation, an enumerator is conceptually positioned before the first
        // element of the enumeration, and the first call to MoveNext 
        // brings the first element of the enumeration into view.
        // 
		public abstract bool MoveNext();
		
        public virtual bool next(){
			return MoveNext();
		}
   
        public abstract void Reset();
        
        
    }
}
