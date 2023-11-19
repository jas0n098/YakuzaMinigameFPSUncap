workspace "AstonMGUncap"
	platforms { "Win64" }

project "AstonMGUncap"
	kind "SharedLib"
	targetextension ".asi"
	language "C++"

	files { "**/MemoryMgr.h", "**/Trampoline.h", "**/Patterns.*" }


workspace "*"
	configurations { "Debug", "Release", "Master" }
	location "build"

	vpaths { ["Headers/*"] = "source/**.h",
			["Sources/*"] = { "source/**.c", "source/**.cpp" },
	}

	files { "source/*.h", "source/*.cpp" }

	cppdialect "C++17"
	staticruntime "on"
	--buildoptions { "/permissive-", "/sdl" }
	warnings "Extra"

filter "configurations:Debug"
	defines { "DEBUG" }
	runtime "Debug"

 filter "configurations:Master"
	defines { "NDEBUG" }
	symbols "Off"

filter "configurations:not Debug"
	optimize "Speed"
	functionlevellinking "on"
	flags { "LinkTimeOptimization" }

filter { "platforms:Win32" }
	system "Windows"
	architecture "x86"

filter { "platforms:Win64" }
	system "Windows"
	architecture "x86_64"
