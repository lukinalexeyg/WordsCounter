#ifndef UTILS_H
#define UTILS_H

#include <QFile>

class Utils
{
public:
    static QString autoDetectCodecText(const QByteArray &data);
    static bool isTextFile(QFile &file, int bytesToCheck = 256);
    static QString timeToString(const qint64 ms, const QString &format);
    static QString separatedNumber(const qint64 number);
};

#endif // UTILS_H
