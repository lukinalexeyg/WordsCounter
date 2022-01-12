#ifndef CORE_H
#define CORE_H

#include <QThread>

#include "worker.h"

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool busy READ isBusy NOTIFY busyChanged)

public:
    explicit Core(QObject *parent = nullptr);
    ~Core();

    Q_INVOKABLE void start(const QString &filePath);
    Q_INVOKABLE void stop();

signals:
    void busyChanged();
    void progressChanged(const QVariantMap &data);
    void finished(const bool ok);
    void fileOpenFinished(const QString &path, const QString &error);

private:
    Worker *m_worker;
    QThread *m_workerThread;
    bool m_busy;

private:
    bool isBusy() const;
};

#endif // CORE_H
