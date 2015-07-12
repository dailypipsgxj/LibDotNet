using System;

namespace System.Collections {

    public interface IStructuralComparable {
        public abstract int32 CompareTo(Object other, IComparer comparer);
    }
}
