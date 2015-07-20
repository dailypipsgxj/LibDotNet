// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IComparer
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Interface for comparing two generic Objects.
**
** 
===========================================================*/
namespace System.Collections.Generic {
    
    using System;
    // The generic IComparer interface implements a method that compares 
    // two objects. It is used in conjunction with the Sort and 
    // BinarySearch methods on the Array, List, and SortedList classes.
    public interface IComparer<T> : GLib.Object
    {
        // Compares two objects. An implementation of this method must return a
        // value less than zero if x is less than y, zero if x is equal to y, or a
        // value greater than zero if x is greater than y.
        // 
        public abstract int Compare(T x, T y);
    }
}
