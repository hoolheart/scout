#ifndef COM_EVENT_ROUTER_H
#define COM_EVENT_ROUTER_H

#include "com_event.h"
#include "com_event_queue.h"

struct event_router_s
{
    void *priv;
    void (*route)(struct event_router_s *router, uint8_t event_type, enum event_queue_type queue_type);
    int (*push)(struct event_router_s *router, struct event_s *event);
};

struct event_router_s *event_router_get();

#endif // COM_EVENT_ROUTER_H
