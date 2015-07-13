namespace System.Collections {

    public interface IStructuralEquatable : Object {
        public abstract bool Equals(Object other, IEqualityComparer comparer);
        public abstract int GetHashCode(IEqualityComparer comparer);
    }
}
