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
using System.Security;

namespace System.Collections.Generic
{
    using System.Globalization;
    using System.Runtime;
    using System.Runtime.CompilerServices;
    using System.Diagnostics.Contracts;

	public delegate uint HashDataFunc<T> (T v);
	public delegate bool EqualDataFunc<T> (T a, T b);


    public abstract class EqualityComparer<T> : GLib.Object, IEqualityComparer<T>
    {
        static EqualityComparer<T> defaultComparer;

        public static EqualityComparer<T> Default<T> () {
			if (typeof(T) == typeof (string)) {
				return new StringEqualityComparer();
			} else if (typeof(T).is_a (typeof (IComparable))) {
				return new GenericEqualityComparer();
			} else {
				return new ObjectEqualityComparer();
			}
        }

        public abstract bool Equals(T x, T y);

        public virtual uint GetHashCode(T obj) {
            if (obj == null) return 0;
            return GLib.direct_hash(obj);
        }

    }




    internal class StringEqualityComparer: EqualityComparer<string>
    {

        public override bool Equals(string x, string y) {
			if (x == y)
				return true;
			else if (x == null || y == null)
				return false;
			else
				return GLib.str_equal ((string) x, (string) y);
        }

        public override uint GetHashCode(string a) {
			if (a == null)
				return (uint)0xdeadbeef;
			else
				return GLib.str_hash ((string) a);
        }


    }

    internal class GenericEqualityComparer: EqualityComparer<IComparable>
    {

        public override bool Equals(IComparable x, IComparable y) {
			if (x == y)
				return true;
			else if (x == null || y == null)
				return false;
			//else
			//	return (x.CompareTo(y) == 0);
			return false;
        }
    }

    internal class ObjectEqualityComparer: EqualityComparer<GLib.Object>
    {
        public override bool Equals(GLib.Object x,GLib.Object y) {
			return GLib.direct_equal(x, y);
        }

    }



}

