#include "headers/write_handler.h"

static void write_handler_delete_previous_file(struct write_handler *self) {
    remove(self->filepath);
}

struct write_handler *write_handler_new(void) {
    struct write_handler *h = (struct write_handler*)malloc(sizeof(struct write_handler));
    h->fd = NULL;
    h->filepath = NULL;

    return h;
}

bool write_handler_open(struct write_handler *self, char *filepath) {
    self->filepath = filepath;
    write_handler_delete_previous_file(self);

    if(!(self->fd = fopen(self->filepath, "w"))) {
        printf("Error on openning file: `%s`\n", self->filepath);
        return false;
    }
    return true;
}

bool write_handler_write(struct write_handler *self, char *str) {
    if(!(fprintf(self->fd, "%s", str))) {
        printf("Error on writting `%s` to file: `%s`\n", str, self->filepath);
        return false;
    }
    return true;
}

bool write_handler_write_line(struct write_handler *self, char *line) {
    if(write_handler_write(self, line))
        return write_handler_write(self, "\n");
    printf("Error on writting line `%s` on file: `%s`\n", line, self->filepath);
    return false;
}

bool write_handler_close(struct write_handler *self) {
    if((fclose(self->fd))) {
        printf("Error on closing file: `%s`\n", self->filepath);
        return false;
    }
    return true;
}
