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

    public abstract class EqualityComparer<T> : IEqualityComparer<T>
    {
        static EqualityComparer<T> defaultComparer;

        public static EqualityComparer<T> Default<T> () {
			EqualityComparer<T> comparer = defaultComparer;
			if (comparer == null) {
				GLib.Type comparer_type = typeof(T);
				//GLib.stdout.puts(comparer_type.name());
				switch (comparer_type.name()) {
					case ("gchararray"):
						comparer = new StringEqualityComparer();
						break;
					case ("gint"):
						comparer = new IntEqualityComparer();
						break;
					case ("glong"):
						comparer = new Int64EqualityComparer();
						break;
					default:
						comparer = new ObjectEqualityComparer();
						break;
					}
				defaultComparer = comparer;
			}
			return comparer;
        }

        public abstract bool Equals(T x, T y);

        public virtual uint GetHashCode(T obj) {
            if (obj == null) return 0;
            return GLib.direct_hash(obj);
        }

        internal virtual int IndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex + count;
            for (int i = startIndex; i < endIndex; i++) {
                if (Equals(array[i], value)) return i;
            }
            return -1;
        }

        internal virtual int LastIndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex - count + 1;
            for (int i = startIndex; i >= endIndex; i--) {
                if (Equals(array[i], value)) return i;
            }
            return -1;
        }


    }


    internal class StringEqualityComparer: EqualityComparer<string>
    {

        public override bool Equals(string x, string y) {
			return GLib.str_equal(x, y);
        }
    }

    internal class ObjectEqualityComparer: EqualityComparer<GLib.Object>
    {
        public override bool Equals(GLib.Object x,GLib.Object y) {
			return GLib.direct_equal(x, y);
        }

    }

    internal class IntEqualityComparer: EqualityComparer<int>
    {

        public override bool Equals(int x, int y) {
			return GLib.int_equal(x, y);
        }

    }

    internal class Int64EqualityComparer: EqualityComparer<int64>
    {

        public override bool Equals(int64 x, int64 y) {
			return GLib.int64_equal(x, y);
        }

    }



}

