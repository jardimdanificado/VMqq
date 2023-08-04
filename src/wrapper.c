#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "main.h"
extern const unsigned char luaJIT_BC_main[];

int main(int argc, char *argv[]) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // Set command-line arguments in Lua environment (arg table)
    lua_newtable(L);
    for (int i = 0; i < argc; ++i) {
        lua_pushstring(L, argv[i]);
        lua_rawseti(L, -2, i);
    }
    lua_setglobal(L, "arg");

    // Load the LuaJIT bytecode from the array
    int result = luaL_loadbuffer(L, (const char*)luaJIT_BC_main, luaJIT_BC_main_SIZE, "main.lua");
    if (result == LUA_OK) {
        // Execute the Lua script
        result = lua_pcall(L, 0, LUA_MULTRET, 0);
        if (result != LUA_OK) {
            printf("Error executing Lua script: %s\n", lua_tostring(L, -1));
        }
    } else {
        printf("Error loading Lua script: %s\n", lua_tostring(L, -1));
    }

    lua_close(L);
    return 0;
}
