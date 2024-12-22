#ifndef COM_EVENT_H
#define COM_EVENT_H

#include <cstdint>

struct event_s
{
    uint8_t type;
    void *data;
};


#endif // COM_EVENT_H
