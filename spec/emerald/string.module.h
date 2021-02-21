#include "cSpec.h"

module(T_string, {
    describe("string", {
        string *str;
        char *initial_value;

        before({
            str = NULL;
            initial_value = "initial";
        });

        it("creates a string with an initial char* using `nassert_that`", {
            str = string_new(initial_value);
            assert_that(str isnot NULL);
        });

        context("when a string pointer is not NULL", {
            it("returns the char* when calling `string_get`", {
                assert_that(sizeof(string_get(str)) is sizeof(char*));
            });
        });
        
        context("when the initial value exitsts", {
            it("returns the correct char* when calling `string_get`", {
                assert_that_charptr(string_get(str) equals to initial_value);
            });
        });

        after({});
    });
});
