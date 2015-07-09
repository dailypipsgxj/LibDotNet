// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// RegexTree is just a wrapper for a node tree with some
// global information attached.

using System.Collections.Generic;

namespace System.Text.RegularExpressions
{
    internal class RegexTree
    {
        internal RegexTree(RegexNode root, Dictionary<int32, int32> caps, int32[] capnumlist, int captop, Dictionary<string, int32> capnames, string[] capslist, RegexOptions opts)
        {
            _root = root;
            _caps = caps;
            _capnumlist = capnumlist;
            _capnames = capnames;
            _capslist = capslist;
            _captop = captop;
            _options = opts;
        }

        internal   RegexNode _root;
        internal   Dictionary<int32, int32> _caps;
        internal   int32[] _capnumlist;
        internal   Dictionary<string, int32> _capnames;
        internal   string[] _capslist;
        internal   RegexOptions _options;
        internal   int _captop;

#if DEBUG
        internal void Dump()
        {
            _root.Dump();
        }

        internal bool Debug
        {
            get
            {
                return (_options & RegexOptions.Debug) != 0;
            }
        }
#endif
    }
}
