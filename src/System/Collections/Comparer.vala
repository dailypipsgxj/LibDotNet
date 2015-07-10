// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  Comparer
**
** Purpose: Compares two objects for equivalence,
**          where string comparisons are case-sensitive.
**
===========================================================*/

using System;
using System.Globalization;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    public class Comparer : Gee.Comparable, IComparer
    {
        public static Comparer Default = new Comparer();
        public static Comparer DefaultInvariant = new Comparer();

        private const string CompareInfoName = "CompareInfo";

        public Comparer()
        {

        }

        // Compares two Objects by calling CompareTo.
        // If a == b, 0 is returned.
        // If a implements IComparable, a.CompareTo(b) is returned.
        // If a doesn't implement IComparable and b does, -(b.CompareTo(a)) is returned.
        // Otherwise an exception is thrown.
        // 
        public int Compare(Object a, Object b)
        {
            if (a == b) return 0;
            if (a == null) return -1;
            if (b == null) return 1;

            IComparable ia = a as IComparable;
            if (ia != null)
                return ia.CompareTo(b);

            IComparable ib = b as IComparable;
            if (ib != null)
                return -ib.CompareTo(a);

            throw ArgumentException(SR.Argument_ImplementIComparable);
        }
    }
}
