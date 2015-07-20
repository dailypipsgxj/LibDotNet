// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
// <OWNER>[....]</OWNER>
// 

using System;
//using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Globalization;
using System.Runtime.CompilerServices;

namespace System.Collections.Generic
{    
 
 	public delegate bool CompareDataFunc<T> (T a, T b);
 
    public abstract class Comparer<T> : GLib.Object, IComparer<T>
    {
        static Comparer<T> defaultComparer;    

        public static Comparer<T> Default<T> () {
			if (typeof(T) == typeof (string)) {
				return new StringComparer();
			} else if (typeof(T).is_a (typeof (IComparable))) {
				return new GenericComparer();
			} else {
				return new ObjectComparer();
			}
        }

        public static Comparer<T> Create<T>(Comparison<T> comparison)
        {
            return new ComparisonComparer<T>(comparison);
        }

        public abstract int Compare(T x, T y);

    }

    internal class StringComparer: Comparer<string>
    {

        public override int Compare(string a, string b) {
			if (a == b)
				return 0;
			else if (a == null)
				return -1;
			else if (b == null)
				return 1;
			else
				return GLib.strcmp((string) a, (string) b);
        }
    }

    internal class GenericComparer: Comparer<IComparable>
    {

        public override int Compare (IComparable a, IComparable b) {
			if (a == b)
				return 0;
			else if (a == null)
				return -1;
			else if (b == null)
				return 1;
			else
				return ((Comparer<IComparable>) a).Compare ((IComparable) a, (IComparable) b);
        }
    }


    internal class ObjectComparer: Comparer<GLib.Object>
    {
        public override int Compare(GLib.Object x,GLib.Object y) {
			if (GLib.direct_equal(x, y)) return 0;
			return -1;
        }

    }


    internal class ComparisonComparer<T> : Comparer<T>
    {
        protected weak Comparison<T> _comparison;

        public ComparisonComparer(Comparison<T> comparison) {
            _comparison = comparison;
        }

        public override int Compare(T x, T y) {
            return _comparison(x, y);
        }
    }
}
