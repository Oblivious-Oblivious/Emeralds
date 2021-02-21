#include "cSpec.h"

void *handler;
void setup_read_handler_object(void) {
    handler = read_handler_new();
}

module(T_read_handler, {
    before_each(&setup_read_handler_object);

    describe("#reader open", {
        context("on reading an existing file", {
            FILE *fd = fopen("new_file.txt", "w");

            it("reads file: `new_file.txt`", {
                bool actual = read_handler_open(handler, "new_file.txt");
                assert_that(actual is true);
            });
        });

        context("on reading an non existent file return false", {
            it("fails to read a file that is not yet created", {
                bool actual = read_handler_open(handler, "this_filename_does_not_exist");
                assert_that(actual is false);
            });
        });
    });

    describe("#read line", {
        it("reads `123 234 345 456 567 678 789` from `test_file.txt`", {
            FILE *fd = fopen("test_file.txt", "w");
            fprintf(fd, "%s", "123 234 345 456 567 678 789\n");
            fprintf(fd, "%s", "another line");
            fclose(fd);

            read_handler_open(handler, "test_file.txt");
            char *actual = read_handler_read_line(handler);
            assert_that_charptr(actual equals to "123 234 345 456 567 678 789");
        });
    });

    describe("#reader close", {
        it("opens a file and successfully closes the buffer", {
            read_handler_open(handler, "new_file.txt");

            bool actual = read_handler_close(handler);
            assert_that(actual is true);
        });
    });

    after({
        remove("new_file.txt");
        remove("test_file.txt");
    });
});
