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
 
    public abstract class Comparer<T> : IComparer<T>
    {
        static Comparer<T> defaultComparer;    

        public static Comparer<T> Default<T> () {
			Comparer<T> comparer = defaultComparer;
			if (comparer == null) {
				GLib.Type comparer_type = typeof(T);
				switch (comparer_type.name()) {
					case ("gchararray"):
						comparer = new StringComparer();
						break;
					case ("gint"):
						comparer = new IntComparer();
						break;
					case ("glong"):
						comparer = new Int64Comparer();
						break;
					default:
						comparer = new ObjectComparer();
						break;
					}
				defaultComparer = comparer;
			}
			return comparer;
        }

        public static Comparer<T> Create<T>(Comparison<T> comparison)
        {
            return new ComparisonComparer<T>(comparison);
        }

        public abstract int Compare(T x, T y);

    }

    internal class StringComparer: Comparer<string>
    {

        public override int Compare(string x, string y) {
			return GLib.strcmp(x, y);
        }
    }

    internal class ObjectComparer: Comparer<GLib.Object>
    {
        public override int Compare(GLib.Object x,GLib.Object y) {
			if (GLib.direct_equal(x, y)) return 0;
			return -1;
        }

    }

    internal class IntComparer: Comparer<int>
    {

        public override int Compare(int x, int y) {
			if (x < y) return -1;
			if (x == y) return 0;
			if (x > y) return 1;
			return 0;
        }

    }

    internal class Int64Comparer: Comparer<int64>
    {

        public override int Compare(int64 x, int64 y) {
			if (x < y) return -1;
			if (x == y) return 0;
			if (x > y) return 1;
			return 0;
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
