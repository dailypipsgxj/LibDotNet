// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
// <OWNER>[....]</OWNER>
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Security;

namespace System.Collections.Generic
{
    using System.Globalization;
    using System.Runtime;
    using System.Runtime.CompilerServices;
    using System.Diagnostics.Contracts;

    public abstract class EqualityComparer<T> : IEqualityComparer, IEqualityComparer<T>
    {
        static EqualityComparer<T> defaultComparer;

        public static EqualityComparer<T> Default {
            get {
                Contract.Ensures(Contract.Result<EqualityComparer<T>>() != null);

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

        int IEqualityComparer.GetHashCode( Object obj) {
            if (obj == null) return 0;
            if (obj is T) return GetHashCode((T)obj);
            ThrowHelper.ThrowArgumentException(ExceptionResource.Argument_InvalidArgumentForComparison);
            return 0;            
        }                        

        bool IEqualityComparer.Equals( Object x, Object y) {
            if (x == y) return true;
            if (x == null || y == null) return false;
            if ((x is T) && (y is T)) return Equals((T)x, (T)y);
            ThrowHelper.ThrowArgumentException(ExceptionResource.Argument_InvalidArgumentForComparison);
            return false;
        }
    }

    // The methods in this class look identical to the inherited methods, but the calls
    // to Equal bind to IEquatable<T>.Equals(T) instead of Object.Equals(Object)
// [Serializable]

    internal class GenericEqualityComparer<T>: EqualityComparer<T>, IEquatable<T>
    {
// [Pure]

        public override bool Equals(T x, T y) {
            if (x != null) {
                if (y != null) return x.Equals(y);
                return false;
            }
            if (y != null) return false;
            return true;
        }
// [Pure]

#if !FEATURE_CORECLR
// [TargetedPatchingOptOut("Performance critical to inline across NGen image boundaries")]

#endif
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
// [Serializable]

    internal class NullableEqualityComparer<T> : EqualityComparer<Nullable<T>>, IEquatable<T>
    {
// [Pure]

        public override bool Equals(Nullable<T> x, Nullable<T> y) {
            if (x.HasValue) {
                if (y.HasValue) return x.value.Equals(y.value);
                return false;
            }
            if (y.HasValue) return false;
            return true;
        }
// [Pure]

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

// [Serializable]

    internal class ObjectEqualityComparer<T>: EqualityComparer<T>
    {
// [Pure]

        public override bool Equals(T x, T y) {
            if (x != null) {
                if (y != null) return x.Equals(y);
                return false;
            }
            if (y != null) return false;
            return true;
        }
// [Pure]

#if !FEATURE_CORECLR
// [TargetedPatchingOptOut("Performance critical to inline across NGen image boundaries")]

#endif
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

    // Performance of IndexOf on byte array is very important for some scenarios.
    // We will call the C runtime function memchr, which is optimized.
// [Serializable]

    internal class ByteEqualityComparer: EqualityComparer<char>
    {
// [Pure]

        public override bool Equals(char x, char y) {
            return x == y;
        }
// [Pure]

        public override int GetHashCode(char b) {
            return b.GetHashCode();
        }
// [System.Security.SecuritySafeCritical]
  // auto-generated
        internal override int IndexOf(char[] array, char value, int startIndex, int count) {
            if (array==null)
                throw ArgumentNullException("array");
            if (startIndex < 0)
                throw ArgumentOutOfRangeException("startIndex", Environment.GetResourcestring("ArgumentOutOfRange_Index"));
            if (count < 0)
                throw ArgumentOutOfRangeException("count", Environment.GetResourcestring("ArgumentOutOfRange_Count"));
            if (count > array.Length - startIndex)
                throw ArgumentException(Environment.GetResourcestring("Argument_InvalidOffLen"));
            Contract.EndContractBlock();
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
// [Serializable]

    internal class EnumEqualityComparer<T>: EqualityComparer<T>
    {
// [Pure]

        public override bool Equals(T x, T y) {
            int x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(x);
            int y_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(y);
            return x_final == y_final;
        }
// [Pure]

        public override int GetHashCode(T obj) {
            int x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCast(obj);
            return x_final.GetHashCode();
        }

    }
// [Serializable]

    internal class LongEnumEqualityComparer<T>: EqualityComparer<T>
    {
// [Pure]

        public override bool Equals(T x, T y) {
            long x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(x);
            long y_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(y);
            return x_final == y_final;
        }
// [Pure]

        public override int GetHashCode(T obj) {
            long x_final = System.Runtime.CompilerServices.JitHelpers.UnsafeEnumCastLong(obj);
            return x_final.GetHashCode();
        }

    }

#if FEATURE_RANDOMIZED_STRING_HASHING
    // This type is not serializeable by design.  It does not exist in previous versions and will be removed 
    // Once we move the framework to using secure hashing by default.
    internal class RandomizedstringEqualityComparer : IEqualityComparerstring>, IEqualityComparer, IWellKnownstringEqualityComparer
    {
        private long _entropy;

        public RandomizedstringEqualityComparer() {
            _entropy = HashHelpers.GetEntropy();
        }

        public new bool Equals( Object x, Object y) {
            if (x == y) return true;
            if (x == null || y == null) return false;
            if ((x is string) && (y is string)) return Equals((string)x, (string)y);
            ThrowHelper.ThrowArgumentException(ExceptionResource.Argument_InvalidArgumentForComparison);
            return false;
        }
// [Pure]


// [SecuritySafeCritical]

        public int GetHashCodestring obj) {
            if(obj == null) return 0;
            returnstring.InternalMarvin32Hashstring(obj, obj.Length, _entropy);
        }
// [Pure]

// [SecuritySafeCritical]

        public int GetHashCode(Object obj) {
            if(obj == null) return 0;

            string sObj = obj as string;
            if(sObj != null) returnstring.InternalMarvin32Hashstring(sObj, sObj.Length, _entropy);

            return obj.GetHashCode(); 
        }

        // Equals method for the comparer itself. 
        public override bool Equals(Object obj) {
            RandomizedstringEqualityComparer comparer = obj as RandomizedstringEqualityComparer; 
            return (comparer != null) && (this._entropy == comparer._entropy);
        }

        public override int GetHashCode() {
            return (this.GetType().Name.GetHashCode() ^ ((int) (_entropy & 0x7FFFFFFF))); 
        }


        IEqualityComparer GetRandomizedEqualityComparer() {
            return new RandomizedstringEqualityComparer();
        }

        // We want to serialize the old comparer.
        IEqualityComparer GetEqualityComparerForSerialization() {
            return EqualityComparer<string>.Default;
        } 
    }

    // This type is not serializeable by design.  It does not exist in previous versions and will be removed 
    // Once we move the framework to using secure hashing by default.
    internal class RandomizedObjectEqualityComparer : IEqualityComparer, IWellKnownStringEqualityComparer
    {
        private long _entropy;

        public RandomizedObjectEqualityComparer() {
            _entropy = HashHelpers.GetEntropy();
        }
// [Pure]

        public new bool Equals(Object x, Object y) {
            if (x != null) {
                if (y != null) return x.Equals(y);
                return false;
            }
            if (y != null) return false;
            return true;
        }
// [Pure]

// [SecuritySafeCritical]

        public int GetHashCode(Object obj) {
            if(obj == null) return 0;

            string sObj = obj as string;
            if(sObj != null) returnstring.InternalMarvin32Hashstring(sObj, sObj.Length, _entropy);

            return obj.GetHashCode();           
        }

        // Equals method for the comparer itself. 
        public override bool Equals(Object obj){
            RandomizedObjectEqualityComparer comparer = obj as RandomizedObjectEqualityComparer; 
            return (comparer != null) && (this._entropy == comparer._entropy);
        }

        public override int GetHashCode() {
            return (this.GetType().Name.GetHashCode() ^ ((int) (_entropy & 0x7FFFFFFF))); 
        }

        IEqualityComparer GetRandomizedEqualityComparer() {
            return new RandomizedObjectEqualityComparer();
        }

        // We want to serialize the old comparer, which in this case was null.
        IEqualityComparer GetEqualityComparerForSerialization() {
            return null;
        }   
    }
#endif
}

