#ifndef MYPORT_H
#define MYPORT_H
#include <serial.h>
#include <QObject>

class Myport : public QObject
{
    Q_OBJECT
public:
    explicit Myport(QObject *parent = nullptr);
private slots:
    void ButtonOpenPort(); // 打开串口按钮-点击槽函数
    void ButtonClearRecv(); // 清除接收文本框按钮-点击槽函数
    void ButtonClearSend(); // 清除发送文本框按钮-点击槽函数
    void ButtonSendDat();   // 发送数据按钮-点击槽函数
    void readSerialDat(); // 读取从自定义串口类获得的数据

signals:
private:
    Serial *my_serial;
    QStringList serialList;

};

#endif // MYPORT_H
