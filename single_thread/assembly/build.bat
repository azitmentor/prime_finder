ml64 /c %1.asm
link %1.obj /subsystem:console kernel32.lib legacy_stdio_definitions.lib msvcrt.lib
