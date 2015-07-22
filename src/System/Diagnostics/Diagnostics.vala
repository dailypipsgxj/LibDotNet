
namespace System.Diagnostics
{

	public abstract class Debug {
		
		public static void Assert( bool condition, string message) {
			GLib.assert(condition);
		}
		
	}

}

namespace System.Diagnostics.Contracts
{

}

namespace System.Diagnostics.CodeAnalysis
{

}
