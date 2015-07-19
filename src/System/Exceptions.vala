namespace System {

	errordomain ArrayTypeMismatchException {
		ARRAYTYPEMISMATCH
	}

	public errordomain ArgumentOutOfRangeException {
		INDEX,
		VALUE,
		NEEDNONNEGNUM,
		BEGININDEXNOTNEGATIVE,
		LENGTHNOTNEGATIVE
	}

	public errordomain Error {
		NOELEMENTS
	}

	errordomain ArgumentException {
		NULL,
		INVALIDOFFSETLENGTH,
		NOTFOUND,
		IMPLEMENTICOMPARABLE,
		INVALID_ARRAY_TYPE
	}

	errordomain ArgumentNullException {
		POINTER,
		VALUE
	}

	errordomain InvalidOperationException {
		ENUMNOTSTARTED,
		ENUMENDED,
		NOTIMPLEMENTED
	}
	
	errordomain NotSupportedException {
		RANGECOLLECTION,
		FIXEDSIZECOLLECTION,
		READONLYCOLLECTION,
		SORTEDLISTNESTEDWRITE,
		KEYCOLLECTIONSET
	}
}
