// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IEqualityComparer
**
** <OWNER>[....]</OWNER>
** 
**
** Purpose: A mechanism to expose a simplified infrastructure for 
**          Comparing objects in collections.
**
** 
===========================================================*/
namespace System.Collections {
    
    using System;
    // An IEqualityComparer is a mechanism to consume custom performant comparison infrastructure
    // that can be consumed by some of the common collections.

    public interface IEqualityComparer {
        public abstract bool Equals(GLib.Object x, GLib.Object y);
        public abstract int GetHashCode(GLib.Object obj);        
    }
}
