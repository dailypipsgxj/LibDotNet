// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Interface:  IEnumerable
** 
** <OWNER>[....]</OWNER>
**
**
** Purpose: Interface for providing generic IEnumerators
**
** 
===========================================================*/
namespace System.Collections.Generic {
    using System;
    using System.Runtime.InteropServices;
    using System.Runtime.CompilerServices;
    using System.Diagnostics.Contracts;
	using System.Linq;
    // Implement this interface if you need to support foreach semantics.

    // Note that T[] : IList<T>, and we want to ensure that if you use
    // IList<YourValueType>, we ensure a YourValueType[] can be used 
    // without jitting.  Hence the TypeDependencyAttribute on SZArrayHelper.
    // This is a special hack internally though - see VM\compile.cpp.
    // The same attribute is on IList<T> and ICollection<T>.

	[GenericAccessors]
    public interface IEnumerable<T> : Enumerable<T>
    {
		public virtual GLib.Type get_element_type () {
			return typeof (T);
		}

		/**
		 * Returns a Iterator that can be used for simple iteration over a
		 * collection.
		 *
		 * @return a Iterator that can be used for simple iteration over a
		 *         collection
		 */
		public abstract IEnumerator<T> iterator ();
		
        // Returns an IEnumerator for this enumerable Object.  The enumerator provides
        // a simple way to access all the contents of a collection.
        public virtual IEnumerator<T> GetEnumerator() {
			return iterator();
		}
    }

}
