using System;

namespace System.Collections {

    public interface IStructuralComparable {
        public abstract int32 CompareTo(GLib.Object other, IComparer comparer);
    }
}
