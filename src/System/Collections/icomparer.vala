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
** Purpose: Interface for comparing two GLib.Objects.
**
** 
===========================================================*/
namespace System.Collections {
    
    using System;
    // The IComparer interface implements a method that compares two objects. It is
    // used in conjunction with the Sort and BinarySearch methods on
    // the Array and List classes.
    // 
    // Interfaces are not serializable

    public interface IComparer {
        // Compares two objects. An implementation of this method must return a
        // value less than zero if x is less than y, zero if x is equal to y, or a
        // value greater than zero if x is greater than y.
        // 
        public abstract int Compare(GLib.Object x, GLib.Object y);
    }
}
