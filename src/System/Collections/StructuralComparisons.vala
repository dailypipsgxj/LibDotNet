// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.


// 

using System;
using System.Collections.Generic;

namespace System.Collections
{
    public class StructuralComparisons
    {
        private static IComparer s_StructuralComparer;
        private static IEqualityComparer s_StructuralEqualityComparer;

        public static IComparer StructuralComparer
        {
            owned get
            {
                IComparer comparer = s_StructuralComparer;
                if (comparer == null)
                {
                    comparer = new StructuralComparerClass();
                    s_StructuralComparer = comparer;
                }
                return comparer;
            }
        }

        public static IEqualityComparer StructuralEqualityComparer
        {
            owned get
            {
                IEqualityComparer comparer = s_StructuralEqualityComparer;
                if (comparer == null)
                {
                    comparer = new StructuralEqualityComparerClass();
                    s_StructuralEqualityComparer = comparer;
                }
                return comparer;
            }
        }
    }

    internal class StructuralEqualityComparerClass : IEqualityComparer
    {
        public new bool Equals(Object x, Object y)
        {
            if (x != null)
            {
                IStructuralEquatable seObj = x as IStructuralEquatable;

                if (seObj != null)
                {
                    return seObj.Equals(y, this);
                }

                if (y != null)
                {
                    return (x==y);
                }
                else
                {
                    return false;
                }
            }
            if (y != null) return false;
            return true;
        }

        public int GetHashCode(Object obj)
        {
            if (obj == null) return 0;

            IStructuralEquatable seObj = obj as IStructuralEquatable;

            if (seObj != null)
            {
                return seObj.GetHashCode(this);
            }

            return -1; //obj.GetHashCode();
        }
    }

    internal class StructuralComparerClass : IComparer
    {
        public int Compare(Object x, Object y)
        {
            if (x == null) return y == null ? 0 : -1;
            if (y == null) return 1;

            IStructuralComparable scX = x as IStructuralComparable;

            if (scX != null)
            {
                return scX.CompareTo(y, this);
            }

            return Comparer<Object>.Default.Compare(x, y);
        }
    }
}
