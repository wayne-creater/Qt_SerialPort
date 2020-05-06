#include "serial.h"

Serial::Serial()
{
    // 初始化串口
    m_serialPort = new QSerialPort;
    serialList= Serial::scanSerial();
     // 当下位机中有数据发送过来时就会响应这个槽函数
//    connect(m_serialPort, SIGNAL(readSignal()), this, SLOT(readSerialData()));
}
QStringList Serial::readList()
{
    return serialList;
}
// 扫描可用串口
QStringList Serial::scanSerial()
{
    QStringList serialStrList;

    // 读取串口信息
    foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
        m_serialPort->setPort(info);
        // 判断端口能否以读写方式打开
        if(m_serialPort->open(QIODevice::ReadWrite))
        {
            serialStrList.append(m_serialPort->portName());
            m_serialPort->close(); // 然后自动关闭等待人为开启（通过"打开串口按钮"）
        }
    }

    return serialStrList;
}

// 打开串口
bool Serial::openPort(QString serialName, QString baudRate, QString dataBit, QString stopBit, QString Parity)
{
    // 设置串口名
    m_serialPort->setPortName(serialName);
    // 打开串口(以读写方式)
    if(m_serialPort->open(QIODevice::ReadWrite))
    {
        m_serialPort->setBaudRate(baudRate.toInt()); // 设置波特率(默认为2400)

        switch (dataBit.toInt()) {
        case 6:
            m_serialPort->setDataBits( QSerialPort::Data6 );
            break;
        case 7:
            m_serialPort->setDataBits( QSerialPort::Data7 );
            break;
        case 8:
            m_serialPort->setDataBits( QSerialPort::Data8 );
            break;

        }
        switch (stopBit.toInt()) {
        case 1:
            m_serialPort->setStopBits( QSerialPort::OneStop );
            break;
        case 2:
            m_serialPort->setStopBits( QSerialPort::TwoStop );
            break;
        }
        switch (Parity.toInt()) {
        case 0:
             m_serialPort->setParity( QSerialPort::NoParity ); // 设置校验位(无校验位)
            break;
        case 2:
             m_serialPort->setParity( QSerialPort::EvenParity ); // 设置校验位(偶校验)
            break;
        case 3:
             m_serialPort->setParity( QSerialPort::OddParity ); // 设置校验位(奇校验)
            break;


        }


        m_serialPort->setFlowControl( QSerialPort::NoFlowControl ); // 设置流控制(无数据流控制)

        // 当下位机中有数据发送过来时就会响应这个槽函数
        connect(m_serialPort, SIGNAL(readyRead()), this, SLOT(readData()));
        // 当下位机中有数据发送过来时就会触发这个信号，以提示其它类对象
        connect(m_serialPort, SIGNAL(readyRead()), this, SIGNAL(readSignal()));

        return true;
    }

    return false;
}

// 关闭串口
void Serial::close()
{
    m_serialPort->clear();
    m_serialPort->close();
}

// 发送数据给下位机
void Serial::sendData(QString dat,bool newLine,bool hexSend )
{
    // 发送数据帧
    if(true==newLine)
    {
        if(false==hexSend)
        {
            m_serialPort->write(dat.toLocal8Bit()+"\r\n");
        }
        else {
            m_serialPort->write((dat.toLocal8Bit()+"\r\n").toHex());
        }
    }
    else if(false==newLine)
    {
        if(false==hexSend)
        {
            m_serialPort->write(dat.toLocal8Bit());
        }
        else {
            m_serialPort->write(dat.toLocal8Bit().toHex());
        }
    }

}

// 读取下位机发来数据
void Serial::readData()
{
    // 将下位机发来数据存储在数据缓冲区
    m_readBuf = m_serialPort->readAll();
}

// 获得读取数据缓冲区
QString Serial::getReadBuf(bool showHex,bool time)
{
    QString buf;
    QString tim;
    QTime local_time=QTime::currentTime();
    tim=local_time.toString("[HH:mm:ss]:");
    if(showHex==true)
    {
        if(time==true)
        {
            buf=tim+m_readBuf.toLocal8Bit().toHex();
        }
        else
        {
            buf=m_readBuf.toLocal8Bit().toHex();
        }
    }
    if(showHex==false)
    {
        if(time==true)
        {
            buf=tim+m_readBuf.toLocal8Bit();
        }
        else
        {
            buf=m_readBuf;
        }
    }
    return buf;
}

// 清除读取数据缓冲区
void Serial::clearReadBuf()
{
    m_readBuf.clear();
}



 //将16进制字符串转换为对应的字节序列
//QByteArray Serial::hexStringToByteArray(QString HexString)
//{
//    bool ok;
//    QByteArray ret;
//    HexString = HexString.trimmed();
//    HexString = HexString.simplified();
//    QStringList sl = HexString.split(" ");

//    foreach (QString s, sl)
//    {
//        if(!s.isEmpty())
//        {
//            char c = static_cast<char>(s.toInt(&ok, 16) & 0xFF);
//            if(ok)
//            {
//                ret.append(c);
//            }
//            else
//            {
//                qDebug()<<"非法的16进制字符："<<s;
//                QMessageBox::warning(nullptr, tr("错误："), QString("非法的16进制字符: \"%1\"").arg(s));
//            }
//        }
//    }

//    return ret;
//}
