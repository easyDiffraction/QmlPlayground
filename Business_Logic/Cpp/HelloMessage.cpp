#include "HelloMessage.h"

QString HelloMessage::randomHello() const {
    return m_hello[qrand() % m_hello.size()];
}
