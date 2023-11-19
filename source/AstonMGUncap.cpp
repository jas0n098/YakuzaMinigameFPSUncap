#define WIN32_LEAN_AND_MEAN
#define NOMINMAX

#define WINVER 0x0601
#define _WIN32_WINNT 0x0601

#include <windows.h>
#include <utility>
#include <cstring>

#include "Utils/MemoryMgr.h"
#include "Utils/Patterns.h"


static void InitASI()
{
	std::unique_ptr<ScopedUnprotect::Unprotect> Protect = ScopedUnprotect::UnprotectSectionOrFullModule( GetModuleHandle( nullptr ), ".shared" );

	using namespace Memory;
	using namespace hook;

	// Uncap minigames which did not need to be capped
	{
		pattern( "74 03 C6 ? 02 FF 05 ? ? ? ?" ).count(16).for_each_result( [] ( pattern_match match ) {
			Nop( match.get<void>(5), 6 );
		} );
	}
}

extern "C"
{
	static LONG InitCount = 0;
	__declspec(dllexport) void InitializeASI()
	{
		if ( _InterlockedCompareExchange( &InitCount, 1, 0 ) != 0 ) return;
		InitASI();
	}
}
