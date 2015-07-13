using System;

namespace System.Collections {

    public interface IStructuralComparable : Object {
        public abstract int32 CompareTo(Object other, IComparer comparer);
    }
}
