#include "core.h"



Core::Core(QObject *parent)
    : QObject{parent},
      m_worker{new Worker},
      m_workerThread{new QThread(this)},
      m_busy(false)
{
    m_workerThread->setObjectName(QStringLiteral("worker"));
    m_worker->moveToThread(m_workerThread);
    connect(m_workerThread, &QThread::finished, m_worker, &QObject::deleteLater);
    m_workerThread->start();

    connect(m_worker, &Worker::busyChanged, this, [this](const bool busy) {
        m_busy = busy;
        emit busyChanged();
    });

    connect(m_worker, &Worker::progressChanged, this, &Core::progressChanged);
    connect(m_worker, &Worker::finished, this, &Core::finished);
    connect(m_worker, &Worker::fileOpenFinished, this, &Core::fileOpenFinished);
}



Core::~Core()
{
    m_workerThread->quit();

    if (!m_workerThread->wait(3000)) {
        m_workerThread->terminate();
        m_workerThread->wait();
    }
}



bool Core::isBusy() const
{
    return m_busy;
}



void Core::start(const QString &filePath)
{
    QMetaObject::invokeMethod(m_worker, "start", Qt::QueuedConnection, Q_ARG(QString, filePath));
}



void Core::stop()
{
    QMetaObject::invokeMethod(m_worker, "stop", Qt::QueuedConnection);
}
