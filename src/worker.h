#ifndef WORKER_H
#define WORKER_H

#include <QElapsedTimer>
#include <QVariant>
#include <QFile>

class Worker : public QObject
{
    Q_OBJECT

public:
    typedef QPair<QString, int> StringIntPair;

public:
    explicit Worker(QObject *parent = nullptr);

    Q_INVOKABLE void start(const QString &filePath);
    Q_INVOKABLE void stop();

signals:
    void busyChanged(const bool busy);
    void progressChanged(const QVariantMap data);
    void finished(const bool ok);
    void fileOpenFinished(const QString path, const QString error = QString());

private:
    typedef QList<int> IntList;
    typedef QHash<QString, int> StringIntHash;
    typedef QMultiMap<int, QString> IntStringMultiMap;
    typedef QVector<StringIntPair> StringIntPairVector;

    StringIntHash m_wordsHash;
    StringIntHash m_changedWordsHash;
    IntStringMultiMap m_wordsMap;

    bool m_enabled;
    QElapsedTimer m_elapsedTimer;
    quint64 m_allWordsCount;
    qreal m_progress;

private:
    bool openFile(QFile &file, const QString &path);
    void run(QFile &file);
    void clear();
    void insertWords(const QStringList &wordsList);

    void emitData();
    bool getData(QStringList &words, IntList &counts);
};

#endif // WORKER_H
