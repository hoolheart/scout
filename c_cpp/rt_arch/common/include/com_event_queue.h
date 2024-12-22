#ifndef COM_EVENT_QUEUE_H
#define COM_EVENT_QUEUE_H

#include "com_event.h"

struct event_queue_s {
    void *priv;
    int (*push)(struct event_queue_s *queue, struct event_s *event);
    int (*pop)(struct event_queue_s *queue, struct event_s *event,
               int timeout_ms);
    void (*clear)(struct event_queue_s *queue);
};

enum event_queue_type {
    EVENT_QUEUE_NORMAL = 0,
    EVENT_QUEUE_IMPORTANT,
    EVENT_QUEUE_CRITICAL,
    EVENT_QUEUE_TYPE_END
};

void event_queue_init();
struct event_queue_s *event_queue_get(enum event_queue_type type);

#endif // COM_EVENT_QUEUE_H
