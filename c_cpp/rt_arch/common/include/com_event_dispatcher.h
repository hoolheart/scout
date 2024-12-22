#ifndef COM_EVENT_DISPATCHER_H
#define COM_EVENT_DISPATCHER_H

#include "com_event.h"

struct event_dispatcher_s {
    void *priv;
    void (*register_handler)(struct event_dispatcher_s *dispatcher,
                             uint8_t type,
                             void (*handler)(struct event_s *event));
    void (*dispatch)(struct event_dispatcher_s *dispatcher,
                     struct event_s *event);
};

struct event_dispatcher_s *event_dispatcher_get();

#endif // COM_EVENT_DISPATCHER_H
