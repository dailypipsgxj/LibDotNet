namespace System {

	errordomain ArrayTypeMismatchException {
		ARRAYTYPEMISMATCH
	}

	errordomain ArgumentOutOfRangeException {
		INDEX,
		VALUE,
		NEEDNONNEGNUM,
		BEGININDEXNOTNEGATIVE,
		LENGTHNOTNEGATIVE
	}

	errordomain ArgumentException {
		NULL,
		INVALIDOFFSETLENGTH,
		NOTFOUND,
		IMPLEMENTICOMPARABLE
	}

	errordomain ArgumentNullException {
		POINTER,
		VALUE
	}

	errordomain InvalidOperationException {
		ENUMNOTSTARTED,
		ENUMENDED
	}
	
	errordomain NotSupportedException {
		RANGECOLLECTION,
		FIXEDSIZECOLLECTION,
		READONLYCOLLECTION,
		SORTEDLISTNESTEDWRITE,
		KEYCOLLECTIONSET
	}
}
