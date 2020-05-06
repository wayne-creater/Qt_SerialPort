import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Styles 1.4
import Serial 1.0
ApplicationWindow {
    id:vindow
    visible: true
    width: 800
    height: 600
    title: qsTr("串口调试助手")
    Material.theme: Material.Dark
    Material.accent: Material.Purple

    Serial{
        id:myserial

        onReadSignal: {
            textRead.append(myserial.getReadBuf(showHex,time))
            myserial.clearReadBuf();

        }

    }

    ScrollView {
        id: scrollView1
        x: 28
        y: 25
        width: 461
        height: 379
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 20
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        clip: true

        TextArea {
            id: textRead
            placeholderText: qsTr("接收区")
            implicitWidth: parent.width
            implicitHeight: parent.height
            wrapMode: Text.Wrap
            focus: true
            selectByMouse: true
        }

    }
    ScrollView {
        id: scrollView2
        x: 28
        y: 25
        width: 461
        height: 120
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 20
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        clip: true
        TextArea {
            id: textWrite
            placeholderText:  qsTr("发送区")
            implicitWidth: parent.width
            implicitHeight: parent.height
            wrapMode: Text.Wrap
            selectByMouse: true

        }
    }


    Column{

        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 15
        spacing: 10
        ComboBox{
            id:port
            model: ["COM1","COM2","COM3","COM4","COM5","COM6"];

        }
        ComboBox{
            id:baud
            model: ["2400","4800","9600","19200","38400","115200"];

        }
        ComboBox{
            id:datBit
            model: ["8","7","6"];

        }
        ComboBox{
            id:stopBit
            model: ["1","2"];
        }
        ComboBox{
            id:parity
            model: ["0","2","3"];
        }

    }
    Column{

        anchors.right: parent.right
        anchors.rightMargin: 150
        anchors.top: parent.top
        anchors.topMargin: 32
        spacing: 40
        Label{
            font.pixelSize: 18
            text: "端口号"
        }
        Label{
            font.pixelSize: 18
            text: "波特率"
        }
        Label{
            font.pixelSize: 18
            text: "数据位"
        }
        Label{
            font.pixelSize: 18
            text: "停止位"
        }
        Label{
            font.pixelSize: 18
            text: "奇偶校验"
        }

    }
    property bool showHex: false;
    property bool time: false
    Row{

        height: 48

        spacing: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 168
        anchors.left: parent.left
        anchors.leftMargin: 15
        CheckBox{
            id: hexShow
            text: "HEX显示"
            onCheckStateChanged: {
                if(checked===true)
                {
                    showHex=true
                }
                else
                {
                    showHex=false
                }

            }

        }
        CheckBox{
            id:timeShow
            text: "时间戳"
            onCheckStateChanged: {
                if(checked===true)
                {
                    time=true
                }
                else
                {
                    time=false
                }
            }
        }

    }
    property bool newLine: false;
    property bool sendHex: false;

    Row{

        spacing: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 15
        CheckBox{
            id: hexSend
            text: "HEX发送"
            onCheckStateChanged: {
                if(checked===true)
                {
                    sendHex=true
                }
                if(checked===false)
                {
                    sendHex=false
                }
            }
        }
        CheckBox{
            id:sendNewline
            text: "发送新行"
            onCheckStateChanged: {
                if(checked==true)
                {
                    newLine=true
                }
                if(checked==false)
                {
                    newLine=false
                }
            }

        }


    }


    Button{
        text: "清除接收"
        height: 35
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 173
        anchors.left: parent.left
        anchors.leftMargin: 400
        onClicked: {
            textRead.clear();
        }
    }
    Button{

        text: "清除发送"
        height: 35
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 400
        onClicked: {
            textWrite.clear()
        }
    }

    Button {
        id: button
        x: 525
        y: 450
        width: 101
        height: 66
        text: qsTr("发送数据")
        onClicked: {
            myserial.sendData(textWrite.text,newLine,sendHex)
        }
    }
    property bool sta: false;
    property int on: 0;
    Button {
        id: button1
        x: 686
        y: 344
        width: 78
        height: 50
        text: qsTr("打开串口")
        onClicked: {

            if(on===0)
            {
                sta=myserial.openPort(port.currentText,baud.currentText,datBit.currentText,stopBit.currentText,parity.currentText)
                if(sta===true)
                {
                    button1.text="关闭串口"
                    on=1
                    console.log("打开成功")
                }
                if(sta===false)
                {
                    console.log("打开失败")
                }

            }
            else if(on===1)
            {
                if(sta===true)
                {
                    myserial.close()
                    button1.text="打开串口"
                    console.log("已关闭串口")
                    sta=false
                    on=0
                }

            }

        }
    }

    Dial {
        id: dial
        x: 729
        y: 535
        width: 67
        height: 62
        onMoved: {
            if(dial.value===1)
            {
                pop1.open();
            }
        }
    }

    Popup{
        id:pop1
        width: 300
        height: 150
        anchors.centerIn: parent
        focus: true
        Label{
            text: "喜欢我的作品吗？"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin:20
        }

        Row{

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            spacing: 40
            Button{
                text: "喜欢"
                onClicked: {
                    pop1.close()
                }

            }
            Button{
                text: "不喜欢"
            }

        }


    }



}



