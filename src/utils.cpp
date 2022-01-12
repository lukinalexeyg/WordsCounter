#include "utils.h"

#include <QTextCodec>
#include <QDateTime>
#include <QLocale>

static constexpr auto s_utf8CodecName = "UTF-8";



bool Utils::isTextFile(QFile &file, int bytesToCheck)
{
    if (bytesToCheck <= 0)
        bytesToCheck = 256;

    const qint64 size = file.size();

    if (size == 0)
        return false;

    const int _size = qMin(static_cast<qint64>(bytesToCheck), size);

    char *data = new char[_size];
    const qint64 count = file.peek(data, _size);

    static const QVector<int> s_controlCharacterIndexes = {0, 1, 2, 3, 4, 5, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18,
                                                           19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 127};

    for (int i = 0; i < count; i++)
        if (s_controlCharacterIndexes.indexOf((uchar)data[i]) != -1) {
            delete [] data;
            return false;
        }

    delete [] data;
    return (count > 0);
}



QString Utils::autoDetectCodecText(const QByteArray &data)
{
    QTextCodec::ConverterState state;
    QTextCodec *codec = QTextCodec::codecForName(s_utf8CodecName);
    const QString string = codec->toUnicode(data.constData(), data.size(), &state);

    if (state.invalidChars > 0) {
        QTextCodec *codec = QTextCodec::codecForLocale();
        if (codec)
            return codec->toUnicode(data);
        return data;
    }

    return string;
}



QString Utils::timeToString(const qint64 ms, const QString &format)
{
    return QDateTime::fromMSecsSinceEpoch(ms).toUTC().toString(format);
}



QString Utils::separatedNumber(const qint64 number)
{
    return QLocale(QLocale::Russian).toString(number);
}
