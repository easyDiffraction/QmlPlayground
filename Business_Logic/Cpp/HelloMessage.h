#include <QObject>
#include <QString>
#include <QStringList>

class HelloMessage : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE QString randomHello() const;

private:
    QStringList m_hello{"Hello World", "Hallo Welt", "Hei maailma", "Hola Mundo"};
};

