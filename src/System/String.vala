using System.Collections.Generic;

namespace System {

	[Compact]
	[Immutable]
	public class String {

		public static string Join (string separator, IEnumerable<string> enumerable) {
			
			string result = "";
			IEnumerator<string> enumerator = enumerable.GetEnumerator();
			
			if(enumerator.MoveNext()) {
				result = enumerator.Current;
			}
			
			while (enumerator.MoveNext()) {
				result += separator + enumerator.Current;
			}
			
			return result;
			
		}

	}
	
}

