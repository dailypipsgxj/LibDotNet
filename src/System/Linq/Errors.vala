// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;

namespace System.Linq
{
	

    internal class Error
    {
		/*
        internal static Exception ArgumentNull(string s) { return new ArgumentNullException(s); }

        internal static Exception ArgumentOutOfRange(string s) { return new ArgumentOutOfRangeException(s); }

        internal static Exception MoreThanOneElement() { return new InvalidOperationException(strings.MoreThanOneElement); }

        internal static Exception MoreThanOneMatch() { return new InvalidOperationException(strings.MoreThanOneMatch); }

        internal static Exception NoElements() { return new InvalidOperationException(strings.NoElements); }

        internal static Exception NoMatch() { return new InvalidOperationException(strings.NoMatch); }

        internal static Exception NotSupported() { return new NotSupportedException(); }
        */
    }

    internal class strings
    {
        internal static string EmptyEnumerable { get { return "SR.EmptyEnumerable"; } }
        internal static string MoreThanOneElement { get { return "SR.MoreThanOneElement"; } }
        internal static string MoreThanOneMatch { get { return "SR.MoreThanOneMatch"; } }
        internal static string NoElements { get { return "SR.NoElements"; } }
        internal static string NoMatch { get { return "SR.NoMatch"; } }
    }
}
