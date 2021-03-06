// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IDictionaryEnumerator
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Base interface for dictionary enumerators.
**
** 
===========================================================*/
namespace System.Collections {
    // Interfaces are not serializable
    
    using System;
    // This interface represents an enumerator that allows sequential access to the
    // elements of a dictionary. Upon creation, an enumerator is conceptually
    // positioned before the first element of the enumeration. The first call to the
    // MoveNext method brings the first element of the enumeration into view,
    // and each successive call to MoveNext brings the next element into
    // view until MoveNext returns false, indicating that there are no more
    // elements to enumerate. Following each call to MoveNext, the
    // Key and Value methods are used to obtain the key and
    // value of the element currently in view. The values returned by calls to
    // Key and Value are undefined before the first call to
    // MoveNext and following a call to MoveNext that returned false.
    // Enumerators are typically used in while loops of the form
    // 
    // IDictionaryEnumerator e = ...;
    // while (e.MoveNext()) {
    //     GLib.Object key = e.Key;
    //     GLib.Object value = e.Value;
    //     ...
    // }
    // 
    // The IDictionaryEnumerator interface extends the IEnumerator
    // inerface and can thus be used as a regular enumerator. The Current 
    // method of an IDictionaryEnumerator returns a DictionaryEntry containing
    // the current key and value pair.  However, the GetEntry method will
    // return the same DictionaryEntry and avoids boxing the DictionaryEntry (boxing
    // is somewhat expensive).
    // 

    public interface IDictionaryEnumerator : IEnumerator
    {
        // Returns the key of the current element of the enumeration. The returned
        // value is undefined before the first call to GetNext and following
        // a call to GetNext that returned false. Multiple calls to
        // GetKey with no intervening calls to GetNext will return
        // the same object.
        // 
        public abstract GLib.Object Key { owned get; }
        
        // Returns the value of the current element of the enumeration. The
        // returned value is undefined before the first call to GetNext and
        // following a call to GetNext that returned false. Multiple calls
        // to GetValue with no intervening calls to GetNext will
        // return the same object.
        // 
        public abstract GLib.Object Value { owned get; }
        
        // GetBlock will copy dictionary values into the given Array.  It will either
        // fill up the array, or if there aren't enough elements, it will
        // copy as much as possible into the Array.  The number of elements
        // copied is returned.
        // 
        public abstract DictionaryEntry Entry { owned get; }
    }
}
