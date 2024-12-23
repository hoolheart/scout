#include "com_event_mechanism.h"
#include "com_ring_buffer.h"

#ifndef NULL
#define NULL ((void *)0)
#endif

struct event_s g_event_buffers[EVENT_QUEUE_TYPE_END][EVENT_QUEUE_SIZE] = {0};

struct event_queue_s g_event_queues[EVENT_QUEUE_TYPE_END] = {0};

int event_queue_push(struct event_queue_s *queue, struct event_s *event) {
    struct ring_buffer_s *rb = NULL;
    int ret = 0;
    if (NULL == queue) {
        return EVENT_QUEUE_INVALID;
    }
    if ((NULL == event) || (event->type > EVENT_TYPE_MAX)) {
        return EVENT_INVALID;
    }
    rb = (struct ring_buffer_s *)(queue->priv);
    ret = rb->push(rb, event);
    if (RING_BUFFER_SUCCESS == ret) {
        return EVENT_QUEUE_SUCCESS;
    } else if (RING_BUFFER_FULL == ret) {
        return EVENT_QUEUE_FULL;
    }
    return EVENT_QUEUE_INVALID;
}

int event_queue_pop(struct event_queue_s *queue, struct event_s *event,
                    int timeout_ms) {
    struct ring_buffer_s *rb = NULL;
    int ret = 0;
    if (NULL == queue) {
        return EVENT_QUEUE_INVALID;
    }
    rb = (struct ring_buffer_s *)(queue->priv);
    ret = rb->pop(rb, event, timeout_ms);
    if (RING_BUFFER_SUCCESS == ret) {
        return EVENT_QUEUE_SUCCESS;
    } else if (RING_BUFFER_EMPTY == ret) {
        return EVENT_QUEUE_EMPTY;
    } else if (RING_BUFFER_TIMEOUT == ret) {
        return EVENT_QUEUE_TIMEOUT;
    }
    return EVENT_QUEUE_INVALID;
}

void event_queue_clear(struct event_queue_s *queue) {
    struct ring_buffer_s *rb = NULL;
    if (NULL == queue) {
        return;
    }
    rb = (struct ring_buffer_s *)(queue->priv);
    rb->clear(rb);
}

void event_queue_init() {
    int i = 0;
    for (i = 0; i < EVENT_QUEUE_TYPE_END; i++) {
        g_event_queues[i].priv = (void *)ring_buffer_create(
            (char *)g_event_buffers[i], sizeof(struct event_s),
            EVENT_QUEUE_SIZE);
        g_event_queues[i].push = event_queue_push;
        g_event_queues[i].pop = event_queue_pop;
        g_event_queues[i].clear = event_queue_clear;
    }
}

struct event_queue_s *event_queue_get(enum event_queue_type type) {
    if ((type < 0) || (type >= EVENT_QUEUE_TYPE_END)) {
        return NULL;
    }
    return &g_event_queues[type];
}

struct event_router_priv_s {
    int prepared;
    enum event_queue_type route_map[EVENT_TYPE_MAX + 1];
    // TODO: locker
};

struct event_router_priv_s g_event_route_priv = {0};

void event_router_route(struct event_router_s *router, uint8_t event_type,
                        enum event_queue_type queue_type) {
    struct event_router_priv_s *priv = NULL;
    if ((NULL == router) || (event_type > EVENT_TYPE_MAX)) {
        return;
    }
    priv = (struct event_router_priv_s *)(router->priv);
    // TODO: lock
    priv->route_map[event_type] = queue_type;
    // TODO: unlock
}

int event_router_push(struct event_router_s *router, struct event_s *event) {
    struct event_router_priv_s *priv = NULL;
    enum event_queue_type queue_type = EVENT_QUEUE_NORMAL;
    struct event_queue_s *queue = NULL;
    if ((NULL == router) || (NULL == event) || (event->type > EVENT_TYPE_MAX)) {
        return EVENT_INVALID;
    }
    priv = (struct event_router_priv_s *)(router->priv);
    // TODO: lock
    queue_type = priv->route_map[event->type];
    // TODO: unlock
    queue = event_queue_get(queue_type);
    return queue->push(queue, event);
}

struct event_router_s g_event_router = {
    .priv = (void *)&g_event_route_priv,
    .route = event_router_route,
    .push = event_router_push,
};

struct event_router_s *event_router_get() {
    int i = 0;
    if (0 == g_event_route_priv.prepared) {
        // TODO: initialize locker
        for (i = 0; i < EVENT_TYPE_MAX + 1; i++) {
            g_event_route_priv.route_map[i] = EVENT_QUEUE_NORMAL;
        }
        g_event_route_priv.prepared = 1;
    }
    return &g_event_router;
}

struct event_dispatcher_priv_s {
    int prepared;
    event_handler_t g_event_handlers[EVENT_TYPE_MAX + 1][EVENT_HANDLER_MAX];
    // TODO: locker
};

struct event_dispatcher_priv_s g_event_dispatcher_priv = {0};

void event_dispatcher_register_handler(struct event_dispatcher_s *dispatcher,
                                       uint8_t type, event_handler_t handler) {
    struct event_dispatcher_priv_s *priv = NULL;
    event_handler_t *handlers = NULL;
    int i = 0;
    if ((NULL == dispatcher) || (type > EVENT_TYPE_MAX) || (NULL == handler)) {
        return EVENT_INVALID;
    }
    priv = (struct event_dispatcher_priv_s *)(dispatcher->priv);
    // TODO: lock
    handlers = priv->g_event_handlers[type];
    for (i = 0; i < EVENT_HANDLER_MAX; i++) {
        if (NULL == handlers[i]) {
            handlers[i] = handler;
            break;
        }
    }
    // TODO: unlock
    return (i < EVENT_HANDLER_MAX) ? EVENT_DISPATCHER_SUCCESS
                                   : EVENT_HANDLER_FULL;
}

void event_dispatcher_dispatch(struct event_dispatcher_s *dispatcher,
                               struct event_s *event) {
    struct event_dispatcher_priv_s *priv = NULL;
    event_handler_t handlers[EVENT_HANDLER_MAX] = {NULL};
    int i = 0;
    if ((NULL == dispatcher) || (NULL == event) ||
        (event->type > EVENT_TYPE_MAX)) {
        return;
    }
    priv = (struct event_dispatcher_priv_s *)(dispatcher->priv);
    // TODO: lock
    memcpy(handlers, priv->g_event_handlers[event->type],
           sizeof(event_handler_t) * EVENT_HANDLER_MAX);
    // TODO: unlock
    for (i = 0; i < EVENT_HANDLER_MAX; i++) {
        if (NULL != handlers[i]) {
            handlers[i](event);
        } else {
            break;
        }
    }
}

struct event_dispatcher_s g_event_dispatcher = {
    .priv = (void *)&g_event_dispatcher_priv,
    .register_handler = event_dispatcher_register_handler,
    .dispatch = event_dispatcher_dispatch,
};

struct event_dispatcher_s *event_dispatcher_get() {
    if (0 == g_event_dispatcher_priv.prepared) {
        // TODO: initialize locker
        g_event_dispatcher_priv.prepared = 1;
    }
    return &g_event_dispatcher;
}

void initial_and_run_event_mechanism() {
    event_queue_init();
    event_router_get();
    event_dispatcher_get();
    // TODO: run event mechanism
}

int push_event(struct event_s *event) {
    struct event_router_s *router = NULL;
    if (NULL == event) {
        return EVENT_INVALID;
    }
    router = event_router_get();
    return router->push(router, event);
}

void register_event_handler(uint8_t event_type, event_handler_t handler) {
    struct event_dispatcher_s *dispatcher = event_dispatcher_get();
    dispatcher->register_handler(dispatcher, event_type, handler);
}
