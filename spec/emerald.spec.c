#include "emerald.spec.h"

/* Define the modules for the spec suite */
spec_suite({
    T_read_handler();
    T_write_handler();
    T_string();
    T_vector();
    T_command_processor();
    T_yaml_processor();
});

/* Execute for all */
spec({
    run_spec_suite("all");
});
