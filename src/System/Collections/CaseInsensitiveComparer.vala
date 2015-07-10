// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class: CaseInsensitiveComparer
**
** Purpose: Compares two objects for equivalence,
**          ignoring the case of strings.
**
============================================================*/

using System;
using System.Collections;
using System.Globalization;
using System.Diagnostics.Contracts;

namespace System.Collections
{
    public class CaseInsensitiveComparer : Gee.Comparable, IComparer
    {
        //private CompareInfo _compareInfo;
        private static CaseInsensitiveComparer s_InvariantCaseInsensitiveComparer;


        public CaseInsensitiveComparer()
        {
        }

        public static CaseInsensitiveComparer Default
        {
            get
            {
                return new CaseInsensitiveComparer();
            }
        }

        public static CaseInsensitiveComparer DefaultInvariant
        {
            get
            {

                if (s_InvariantCaseInsensitiveComparer == null)
                {
                    s_InvariantCaseInsensitiveComparer = new CaseInsensitiveComparer();
                }
                return s_InvariantCaseInsensitiveComparer;
            }
        }

        // Behaves exactly like Comparer.Default.Compare except that the comparison is case insensitive
        // Compares two Objects by calling CompareTo.
        // If a == b, 0 is returned.
        // If a implements IComparable, a.CompareTo(b) is returned.
        // If a doesn't implement IComparable and b does, -(b.CompareTo(a)) is returned.
        // Otherwise an exception is thrown.
        // 
        public int Compare(Object a, Object b)
        {
            string sa = a as string;
            string sb = b as string;
            if (sa != null && sb != null)
                return _compareInfo.Compare(sa, sb, CompareOptions.IgnoreCase);
            else
                return Comparer.Default.Compare(a, b);
        }
        
        public int compare_to (Object a)
        {
			Compare (this, a);
		}
    }
}
