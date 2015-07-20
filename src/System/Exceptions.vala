namespace System {

	public errordomain ArrayTypeMismatchException {
		ARRAY_TYPE_MISMATCH
	}

	public errordomain ArgumentOutOfRangeException {
		INDEX,
		VALUE,
		NEED_NON_NEG_NUM,
		BEGIN_INDEX_NOT_NEGATIVE,
		LENGTH_NOT_NEGATIVE
	}

	public errordomain Error {
		NOELEMENTS
	}

	public errordomain ArgumentException {
		NULL,
		INVALID_OFFSET_LENGTH,
		NOT_FOUND,
		IMPLEMENT_ICOMPARABLE,
		INVALID_ARRAY_TYPE,
		ADDING_DUPLICATE
	}

	public errordomain ArgumentNullException {
		POINTER,
		VALUE
	}

	public errordomain InvalidOperationException {
		ENUM_NOT_STARTED,
		ENUM_ENDED,
		NOT_IMPLEMENTED,
		COMPARE_FAILED
	}
	
	public errordomain NotSupportedException {
		RANGE_COLLECTION,
		FIXED_SIZE_COLLECTION,
		READ_ONLY_COLLECTION,
		SORTED_LIST_NESTED_WRITE,
		KEY_COLLECTION_SET
	}
}
