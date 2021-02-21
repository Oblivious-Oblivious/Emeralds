/* Library includes */
#include "sources/emerald.h"

/* Spec includes */
#include "emerald/string.module.h"
#include "emerald/vector.module.h"
#include "emerald/read_handler.module.h"
#include "emerald/write_handler.module.h"

/* Define the modules for the spec suite */
spec_suite({
    T_read_handler();
    T_write_handler();
    T_string();
    T_vector();
});

/* Execute for all */
spec({
    run_spec_suite("all");
});
