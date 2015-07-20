// ==++==
// 
//   API Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IReadOnlyCollection<T>
** Purpose: Base interface for read-only generic lists.
** 
===========================================================*/
using System;
using System.Diagnostics.Contracts;
using System.Runtime.CompilerServices;

namespace System.Collections.Generic
{

    // Provides a read-only, covariant view of a generic list.
   	//[GenericAccessors]
    public interface IReadOnlyCollection<T>
    {

		/**
		 * The number of items in this collection.
		 */
		public abstract int size { get; }
        public abstract int Count { get; }

    }

}
