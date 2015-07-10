namespace System.Collections {

    public interface IStructuralEquatable {
        bool Equals(Object other, IEqualityComparer comparer);
        int GetHashCode(IEqualityComparer comparer);
    }
}
