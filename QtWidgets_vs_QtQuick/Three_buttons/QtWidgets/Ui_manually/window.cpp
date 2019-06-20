#include <QVBoxLayout>
#include <QPushButton>
#include "window.h"

Window::Window(QWidget *parent)
    : QWidget(parent)
{
    resize(400, 300);
    setWindowTitle("QtWidgets: Hello World!");

    QVBoxLayout *layout = new QVBoxLayout;

    QPushButton *one = new QPushButton("One");
    layout->addWidget(one);

    QPushButton *two = new QPushButton("Two");
    layout->addWidget(two);

    QPushButton *three = new QPushButton("Three");
    layout->addWidget(three);

    setLayout(layout);
}
