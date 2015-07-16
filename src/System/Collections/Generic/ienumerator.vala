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
    public interface IEnumerator<T> : IDisposable, System.Collections.IEnumerator
    {    
        // Returns the current element of the enumeration. The returned value is
        // undefined before the first call to MoveNext and following a
        // call to MoveNext that returned false. Multiple calls to
        // GetCurrent with no intervening calls to MoveNext 
        // will return the same object.
        // 
        public abstract T Current { owned get; }
    }
}
