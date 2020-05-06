#include "myport.h"

Myport::Myport(QObject *parent) : QObject(parent)
{
    my_serial=new Serial;
    serialList= my_serial->scanSerial();

    // 当下位机中有数据发送过来时就会响应这个槽函数
    connect(my_serial,SIGNAL(readSignal()),this,SLOT(readSerialDat()));


}


