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

        public static EqualityComparer<T> Default {
            owned get {
                EqualityComparer<T> comparer = defaultComparer;
                if (comparer == null) {
                    comparer = CreateComparer();
                    defaultComparer = comparer;
                }
                return comparer;
            }
        }

        private static EqualityComparer<T> CreateComparer() {
            return new ObjectEqualityComparer<T>();
        }

        public abstract bool Equals(T x, T y);

        public abstract int GetHashCode(T obj);

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

    // The methods in this class look identical to the inherited methods, but the calls
    // to Equal bind to IEquatable<T>.Equals(T) instead of Object.Equals(Object)

    internal class GenericEqualityComparer<T>: EqualityComparer<T>, IEquatable<T>
    {

        public override bool Equals(T x, T y) {
            if (x != null) {
                if (y != null) return x.Equals(y);
                return false;
            }
            if (y != null) return false;
            return true;
        }

        public override int GetHashCode(T obj) {
            if (obj == null) return 0;
            return obj.GetHashCode();
        }

        internal override int IndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex + count;
            if (value == null) {
                for (int i = startIndex; i < endIndex; i++) {
                    if (array[i] == null) return i;
                }
            }
            else {
                for (int i = startIndex; i < endIndex; i++) {
                    if (array[i] != null && array[i].Equals(value)) return i;
                }
            }
            return -1;
        }

        internal override int LastIndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex - count + 1;
            if (value == null) {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (array[i] == null) return i;
                }
            }
            else {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (array[i] != null && array[i].Equals(value)) return i;
                }
            }
            return -1;
        }

    }

    internal class NullableEqualityComparer<T> : EqualityComparer<Nullable<T>>, IEquatable<T>
    {
        public override bool Equals(Nullable<T> x, Nullable<T> y) {
            if (x.HasValue) {
                if (y.HasValue) return x.value.Equals(y.value);
                return false;
            }
            if (y.HasValue) return false;
            return true;
        }

        public override int GetHashCode(Nullable<T> obj) {
            return obj.GetHashCode();
        }

        internal override int IndexOf(Nullable<T>[] array, Nullable<T> value, int startIndex, int count) {
            int endIndex = startIndex + count;
            if (!value.HasValue) {
                for (int i = startIndex; i < endIndex; i++) {
                    if (!array[i].HasValue) return i;
                }
            }
            else {
                for (int i = startIndex; i < endIndex; i++) {
                    if (array[i].HasValue && array[i].value.Equals(value.value)) return i;
                }
            }
            return -1;
        }

        internal override int LastIndexOf(Nullable<T>[] array, Nullable<T> value, int startIndex, int count) {
            int endIndex = startIndex - count + 1;
            if (!value.HasValue) {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (!array[i].HasValue) return i;
                }
            }
            else {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (array[i].HasValue && array[i].value.Equals(value.value)) return i;
                }
            }
            return -1;
        }

    }


    internal class ObjectEqualityComparer<T>: EqualityComparer<T>
    {

        public override bool Equals(T x, T y) {
            if (x != null) {
                if (y != null) return (x == y);
                return false;
            }
            if (y != null) return false;
            return true;
        }

        public override int GetHashCode(T obj) {
            if (obj == null) return 0;
            return -1;// obj.GetHashCode();
        }

        internal override int IndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex + count;
            if (value == null) {
                for (int i = startIndex; i < endIndex; i++) {
                    if (array[i] == null) return i;
                }
            }
            else {
                for (int i = startIndex; i < endIndex; i++) {
                    if (array[i] != null && array[i] == value) return i;
                }
            }
            return -1;
        }

        internal override int LastIndexOf(T[] array, T value, int startIndex, int count) {
            int endIndex = startIndex - count + 1;
            if (value == null) {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (array[i] == null) return i;
                }
            }
            else {
                for (int i = startIndex; i >= endIndex; i--) {
                    if (array[i] != null && array[i] == value) return i;
                }
            }
            return -1;
        }

    }

    // Performance of IndexOf on byte array is very important for some scenarios.
    // We will call the C runtime function memchr, which is optimized.

    internal class ByteEqualityComparer: EqualityComparer<char>
    {

        public override bool Equals(char x, char y) {
            return x == y;
        }

        public override int GetHashCode(char b) {
            return b.GetHashCode();
        }

        internal override int IndexOf(char[] array, char value, int startIndex, int count) {
            if (array==null)
                throw new ArgumentNullException("array");
            if (startIndex < 0)
                throw new ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            if (count < 0)
                throw new ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_Count"));
            if (count > array.Length - startIndex)
                throw new ArgumentException(Environment.GetResourcestring("Argument_InvalidOffLen"));

            if (count == 0) return -1;
            char* pbytes = array;
            return Buffer.IndexOfByte(pbytes, value, startIndex, count);
        }

        internal override int LastIndexOf(char[] array, char value, int startIndex, int count) {
            int endIndex = startIndex - count + 1;
            for (int i = startIndex; i >= endIndex; i--) {
                if (array[i] == value) return i;
            }
            return -1;
        }

       
    }

    internal class EnumEqualityComparer<T>: EqualityComparer<T>
    {
        public override bool Equals(T x, T y) {
            int x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(x);
            int y_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(y);
            return x_final == y_final;
        }

        public override int GetHashCode(T obj) {
            int x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(obj);
            return x_final.GetHashCode();
        }

    }

    internal class LongEnumEqualityComparer<T>: EqualityComparer<T>
    {

        public override bool Equals(T x, T y) {
            long x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(x);
            long y_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(y);
            return x_final == y_final;
        }

        public override int GetHashCode(T obj) {
            long x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(obj);
            return x_final.GetHashCode();
        }

    }

}

