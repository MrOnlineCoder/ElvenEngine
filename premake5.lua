workspace "Elven"
    architecture "x64"
    startproject "Sandbox"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Elven/vendor/GLFW/include"
IncludeDir["Glad"] = "Elven/vendor/Glad/include"

include "Elven/vendor/GLFW"
include "Elven/vendor/GLAD"

project "Elven"
    location "Elven"
    kind "SharedLib"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader "elpch.h"
    pchsource "Elven/src/elpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs 
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}"
    }

    links
    {
        "GLFW",
        "GLAD",
        "opengl32.lib"
    }

    defines
    {
        "GLFW_INCLUDE_NONE",
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "EL_PLATFORM_WINDOWS",
            "EL_BUILD_DLL",
        }

        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
        }

    filter "configurations:Debug"
        defines "EL_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "EL_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "EL_DIST"
        buildoptions "/MD"
        optimize "On"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Elven/vendor/spdlog/include",
        "Elven/src"
    }
    
    links 
    {
        "Elven"
    }

    filter "system:windows"
        systemversion "latest"

        defines
        {
            "EL_PLATFORM_WINDOWS"
        }

        filter "configurations:Debug"
            defines "EL_DEBUG"
            buildoptions "/MDd"
            symbols "On"

        filter "configurations:Release"
            defines "EL_RELEASE"
            buildoptions "/MD"
            optimize "On"

        filter "configurations:Dist"
            defines "EL_DIST"
            buildoptions "/MD"
            optimize "On"