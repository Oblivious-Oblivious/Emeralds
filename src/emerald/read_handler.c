#include "headers/read_handler.h"

static bool read_handler_file_does_not_exist(struct read_handler *self) {
    /* Try to open for reading */
    FILE *f;
    if((f = fopen(self->filepath, "r"))) {
        fclose(f);
        return false;
    }
    printf("File: `%s` does not exist\n", self->filepath);
    return true;
}

struct read_handler *read_handler_new(void) {
    struct read_handler *h = (struct read_handler*)malloc(sizeof(struct read_handler));
    h->fd = NULL;
    h->filepath = NULL;

    return h;
}

bool read_handler_open(struct read_handler *self, char *filepath) {
    self->filepath = filepath;

    if(read_handler_file_does_not_exist(self)) return false;
    
    if(!(self->fd = fopen(self->filepath, "r"))) {
        printf("Error on reading file: `%s`\n", self->filepath);
        return false;
    }
    return true;
}

char *read_handler_read_line(struct read_handler *self) {
    char *ret;
    size_t line_len;
    char buf[2];

    size_t len = sizeof(buf);
    char *line = (char*)malloc(len);
    if(line == NULL) {
        printf("Error on allocating memory for the buffer\n");
        return "";
    }
    line[0] = '\0';

    while(fgets(buf, sizeof(buf), self->fd) != NULL) {
        /* Resize when necessary */
        if(len - strlen(line) < sizeof(buf)) {
            len *= 2;
            if((line = realloc(line, len)) == NULL) {
                printf("Error on reallocating space for a bigger buffer\n");
                free(line);
                return "";
            }
        }

        /* Append the buffer to the end of the line */
        strcat(line, buf);

        /* Reduce the buffer to the first line */
        line_len = strlen(line);
        if(line[line_len - 1] == '\n') {
            ret = (char*)malloc(sizeof(char) * line_len);
            strcpy(ret, line);
            free(line);
            ret[line_len - 1] = '\0';
            return ret;
        }
    }

    return line;
}

bool read_handler_close(struct read_handler *self) {
    if((fclose(self->fd))) {
        printf("Error on closing file: `%s`\n", self->filepath);
        return false;
    }
    return true;
}
