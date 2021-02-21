#include "cSpec.h"

module(T_vector, {
    describe("vector", {
        vector *v;
        int a, b, c;

        before({
            v = NULL;
            a = 1;
            b = 2;
            c = 4;
        });

        it("creates a new vector", {
            v = vector_new();
            assert_that(v isnot NULL);
        });

        it("adds exactly three elements to the vector", {
            vector_add(v, a);
            vector_add(v, b);
            vector_add(v, c);
            assert_that_int(vector_length(v) equals to 3);
        });

        it("peeks the second element of the vector", {
            assert_that_int(vector_get(v, 1) equals to b);
        });

        it("removes the second element of the vector", {
            vector_delete(v, 1);
            assert_that_int(vector_get(v, 1) equals to c);
        });
    });
});
