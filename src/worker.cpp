#include "worker.h"

#include "utils.h"

#include <QApplication>

static constexpr auto s_textCodecType = 0; // 0 - auto, 1 - UTF-8, 2 - local8Bit

static constexpr auto s_digitsEnabled = false;
static constexpr auto s_caseSensitivityEnabled = false;

static constexpr auto s_updateInterval = 100;
static constexpr auto s_wordsToShowCount = 15;
static constexpr auto s_alphabeticallySortEnabled = true;

static const QLatin1Char s_spaceChar(' ');



Worker::Worker(QObject *parent)
    : QObject{parent},
      m_enabled(false)
{
}



void Worker::start(const QString &filePath)
{
    emit busyChanged(true);
    QFile file;

    if (!openFile(file, filePath)) {
        emit busyChanged(false);
        return;
    }

    m_enabled = true;
    run(file);

    file.close();
    emit busyChanged(false);
}



void Worker::stop()
{
    m_enabled = false;
}



bool Worker::openFile(QFile &file, const QString &path)
{
    QString _path = path;

    if (_path.startsWith(QStringLiteral("file:///")))
        _path.remove(0, 8);

    file.setFileName(_path);

    if (file.size() == 0) {
        emit fileOpenFinished(_path, "Файл пустой");
        return false;
    }

    if (!file.open(QFile::ReadOnly | QFile::Text)) {
        emit fileOpenFinished(_path, file.errorString());
        return false;
    }

    if (!Utils::isTextFile(file)) {
        file.close();
        emit fileOpenFinished(_path, "Файл не является текстовым файлом");
        return false;
    }

    emit fileOpenFinished(_path);
    return true;
}



void fixString(QString &string)
{
    std::replace_if(string.begin(), string.end(), [](const QChar &c) {
        return ((s_digitsEnabled && !c.isLetterOrNumber()) || (!s_digitsEnabled && !c.isLetter()))
                && c != QLatin1Char('_');
    }, s_spaceChar);
}



void Worker::run(QFile &file)
{
    clear();

    m_allWordsCount = 0;
    m_progress = 0.0;

    const qreal fileSize = static_cast<qreal>(file.size());
    qint64 pos = 0;

    qint64 updateTime = s_updateInterval;
    m_elapsedTimer.start();

    while (!file.atEnd() && m_enabled) {
        const QByteArray line = file.readLine();
        pos += line.count();

        QString string
                = (s_textCodecType == 0)
                ? Utils::autoDetectCodecText(line)
                : (s_textCodecType == 1)
                  ? QString::fromUtf8(line)
                  : QString::fromLocal8Bit(line);

        fixString(string);

        const QStringList wordsList = string.split(s_spaceChar, Qt::SkipEmptyParts);

        if (!wordsList.isEmpty()) {
            m_allWordsCount += wordsList.count();
            insertWords(wordsList);
        }

        if (m_elapsedTimer.hasExpired(updateTime)) {
            updateTime += s_updateInterval;
            m_progress = static_cast<qreal>(pos)/fileSize;
            emitData();
            qApp->processEvents();
        }
    }

    if (m_enabled) {
        m_progress = 1.0;
        emitData();
        emit finished(true);
    }
    else
        emit finished(false);

    clear();
}



void Worker::clear()
{
    m_wordsHash.clear();
    m_changedWordsHash.clear();
    m_wordsMap.clear();
}



void Worker::insertWords(const QStringList &wordsList)
{
    for (const QString &word : qAsConst(wordsList)) {
        const QString _word = s_caseSensitivityEnabled ? word : word.toLower();
        const auto it = m_wordsHash.find(_word);
        int value = 1;

        if (it == m_wordsHash.end())
            m_wordsHash.insert(_word, 1);
        else {
            it.value()++;
            value = it.value();
        }

        m_changedWordsHash.insert(_word, value);
    }
}



void Worker::emitData()
{
    QVariantMap map;

    if (!m_changedWordsHash.isEmpty()) {
        QStringList words;
        IntList counts;

        if (getData(words, counts)) {
            m_changedWordsHash.clear();

            map.insert(QStringLiteral("words"),             words);
            map.insert(QStringLiteral("counts"),            QVariant::fromValue(counts));
            map.insert(QStringLiteral("allWordsCount"),     Utils::separatedNumber(m_allWordsCount));
            map.insert(QStringLiteral("uniqueWordsCount"),  Utils::separatedNumber(m_wordsHash.count()));
        }
    }

    const qint64 elapsedTime = m_elapsedTimer.elapsed();

    map.insert(QStringLiteral("elapsedTime"), Utils::timeToString(elapsedTime, QStringLiteral("hh:mm:ss.zzz")));
    map.insert(QStringLiteral("progress"), m_progress);

    emit progressChanged(map);
}



bool compareWords(const Worker::StringIntPair &a, const Worker::StringIntPair &b)
{
    return a.first > b.first;
};



bool Worker::getData(QStringList &words, IntList &counts)
{
    bool changed = false;

    for (auto h = m_changedWordsHash.cbegin(); h != m_changedWordsHash.cend(); ++h) {
        auto m = m_wordsMap.end();

        for (auto it = m_wordsMap.end()-1; it != m_wordsMap.begin()-1; --it)
            if (it.value() == h.key()) {
                m = it;
                break;
            }

        if (m != m_wordsMap.end()) {
            m_wordsMap.erase(m);
            m_wordsMap.insert(h.value(), h.key());
            changed = true;
        }

        else if (m_wordsMap.count() < s_wordsToShowCount) {
            m_wordsMap.insert(h.value(), h.key());
            changed = true;
        }

        else {
            const int minWordsCount
                    = /*m_wordsMap.isEmpty()
                    ? 0
                    :*/ (m_wordsMap.count() >= s_wordsToShowCount)
                      ? (m_wordsMap.end() - s_wordsToShowCount).key()
                      : m_wordsMap.firstKey();
            if (h.value() > minWordsCount) {
                m_wordsMap.insert(h.value(), h.key());
                changed = true;
            }
        }
    }

    if (!changed)
        return false;

    const int itemsToRemoveCount = m_wordsMap.count() - s_wordsToShowCount;

    for (int i = 0; i < itemsToRemoveCount; ++i)
        m_wordsMap.erase(m_wordsMap.begin());

    StringIntPairVector vector;

    for (auto it = m_wordsMap.cbegin(); it != m_wordsMap.cend(); ++it) {
        const StringIntPair pair(it.value(), it.key());
        vector.append(pair);
    }

    if (s_alphabeticallySortEnabled)
        std::sort(vector.begin(), vector.end(), compareWords);

    for (const StringIntPair &pair : qAsConst(vector)) {
        words.append(pair.first);
        counts.append(pair.second);
    }

    return true;
}
