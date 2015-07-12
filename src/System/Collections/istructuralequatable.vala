namespace System.Collections {

    public interface IStructuralEquatable {
        public abstract bool Equals(Object other, IEqualityComparer comparer);
        public abstract int GetHashCode(IEqualityComparer comparer);
    }
}
