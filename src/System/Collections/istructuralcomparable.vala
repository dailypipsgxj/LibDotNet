using System;

namespace System.Collections {

    public interface IStructuralComparable {
        int32 CompareTo(Object other, IComparer comparer);
    }
}
