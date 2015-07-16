namespace System.Collections {

    public interface IStructuralEquatable {
        public abstract bool Equals(GLib.Object other, IEqualityComparer comparer);
        public abstract int GetHashCode(IEqualityComparer comparer);
    }
}
