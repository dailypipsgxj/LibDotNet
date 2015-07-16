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
using System.Diagnostics.Contracts;
using System.Globalization;
using System.Runtime.CompilerServices;

namespace System.Collections.Generic
{    
 
    public abstract class Comparer<T> : Object, IComparer<T>, System.Collections.IComparer
    {
        static Comparer<T> defaultComparer;    

		protected Comparer () {
		
		}

        public static Comparer<T> Default {
            owned get {
                Comparer<T> comparer = defaultComparer;
                if (comparer == null) {
                    comparer = CreateComparer();
                    defaultComparer = comparer;
                }
                return comparer;
            }
        }

        public static Comparer<T> Create(Comparison<T> comparison)
        {
            return new ComparisonComparer<T>(comparison);
        }

        //
        // Note that logic in this method is replicated in vm\compile.cpp to ensure that NGen
        // saves the right instantiations
        //
        private static Comparer<T> CreateComparer() {
          // Otherwise return an ObjectComparer<T>
			return new GenericComparer<T>();
        }

        public virtual int Compare(T x, T y) {
			return -1;
		}

    }

    public class GenericComparer<T> : Comparer<T>
    {    

        public override int Compare(T x, T y) {
            if (x != null) {
                if (y != null) return (int)(x == y);
                return 1;
            }
            if (y != null) return -1;
            return 0;
        }


        // Equals method for the comparer itself. 
        public bool Equals(Object obj){
            GenericComparer<T> comparer = obj as GenericComparer<T>;
            return comparer != null;
        }        

        public int GetHashCode() {
            return -1;
        }
    }

    internal class NullableComparer<T> : Comparer<Nullable<T>> 
    {
        public override int Compare(Nullable<T> x, Nullable<T> y) {
            if (x.HasValue) {
                if (y.HasValue) return (int)(x.value == y.value);
                return 1;
            }
            if (y.HasValue) return -1;
            return 0;
        }

        // Equals method for the comparer itself. 
        public bool Equals(Object obj){
            NullableComparer<T> comparer = obj as NullableComparer<T>;
            return comparer != null;
        }        


        public int GetHashCode() {
            return -1;
        }
    }

    public class ObjectComparer<T> : Comparer<T>
    {
        public int Compare(T x, T y) {
            return System.Collections.Comparer.Default.Compare(x as Object, y as Object);
        }

        // Equals method for the comparer itself. 
        public bool Equals(Object obj){
            ObjectComparer<T> comparer = obj as ObjectComparer<T>;
            return comparer != null;
        }        

        public int GetHashCode() {
            return -1;
        }
    }

    internal class ComparisonComparer<T> : Comparer<T>
    {
        protected weak Comparison<T> _comparison;

        public ComparisonComparer(Comparison<T> comparison) {
            _comparison = comparison;
        }

        public int Compare(T x, T y) {
            return _comparison(x, y);
        }
    }
}
